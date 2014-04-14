Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaDNHlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:41:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:54788 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbaDNHlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:41:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,855,1389772800"; 
   d="scan'208";a="520306192"
Message-ID: <534B93BA.6020406@linux.intel.com>
Date: Mon, 14 Apr 2014 10:52:26 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Timur Tabi <timur@codeaurora.org>
CC: Linus <linus.walleij@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>	<1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com> <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com>
In-Reply-To: <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2014 01:54 AM, Timur Tabi wrote:
> On Tue, Jun 18, 2013 at 6:33 AM, Mathias Nyman
> <mathias.nyman@linux.intel.com> wrote:
>>
>> Pins may be muxed to alternate function instead of gpio by firmware.
>> This driver does not touch the pin muxing and expect firmare
>> to set pin muxing and pullup/down properties properly.
>>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> ---
>>   drivers/pinctrl/Kconfig            |   12 +
>>   drivers/pinctrl/Makefile           |    1 +
>>   drivers/pinctrl/pinctrl-baytrail.c |  543 ++++++++++++++++++++++++++++++++++++
>
>
> I know it's been ten months since you posted this driver, but I have a
> question.  If this driver does not touch the pin muxing, and it
> doesn't even call pinctrl_register(), then why is it in
> drivers/pinctrl?  It's not a pinctrl driver.  Why isn't this a regular
> GPIO drivers in drivers/gpio?
>

This was the conclusion we reached after some discussion with Linus W.
Initially this was just a GPIO driver, but Linus correctly spotted that 
Baytrail has many pinctrl-like features (like pin muxing, etc) that we 
might need to address in the future.

threads where this was discussed:

http://marc.info/?l=linux-kernel&m=136994203308585&w=2
http://marc.info/?l=linux-kernel&m=137113578604763&w=2

-Mathias

