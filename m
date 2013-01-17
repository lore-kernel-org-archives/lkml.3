Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab3AQJMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:12:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36180 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792Ab3AQJMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:12:50 -0500
Message-ID: <50F7C074.5070803@ti.com>
Date: Thu, 17 Jan 2013 11:12:20 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <bjorn@mork.no>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 03/22] mfd: omap-usb-tll: Use devm_kzalloc/ioremap
 and clean up error path
References: <1358347433-329-1-git-send-email-rogerq@ti.com> <1358347433-329-4-git-send-email-rogerq@ti.com> <50F70164.3080105@mvista.com>
In-Reply-To: <50F70164.3080105@mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 09:37 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 01/16/2013 05:43 PM, Roger Quadros wrote:
> 
>> Use devm_ variants of kzalloc() and ioremap(). Simplify the error path.
> 
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  drivers/mfd/omap-usb-tll.c |   36 +++++++++++-------------------------
>>  1 files changed, 11 insertions(+), 25 deletions(-)
> 
>> diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
>> index 9658e18..53ed10b 100644
>> --- a/drivers/mfd/omap-usb-tll.c
>> +++ b/drivers/mfd/omap-usb-tll.c
> [...]
>> -	base = ioremap(res->start, resource_size(res));
>> +	base = devm_request_and_ioremap(dev, res);
>>  	if (!base) {
>> -		dev_err(dev, "TLL ioremap failed\n");
>>  		ret = -ENOMEM;
> 
>    -EADDRNOTAVAIL as the comment to devm_request_and_ioremap() suggests.
> 

I changed it deliberately to ENOMEM, as I could not find EADDRNOTAVAIL
defined in all architectures.

ENOMEM shouldn't harm.

cheers,
-roger
