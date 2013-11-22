Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3KVQpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:45:15 -0500
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:43593
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755339Ab3KVQpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:45:13 -0500
Message-ID: <528F8A18.5080807@newflow.co.uk>
Date: Fri, 22 Nov 2013 16:45:12 +0000
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michael Grzeschik <mgr@pengutronix.de>
CC: linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, bigeasy@linutronix.de,
        Greg KH <gregkh@linuxfoundation.org>, jkosina@suse.cz,
        anatol.pomozov@gmail.com,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] Allow MUSB DSPS to use "force host" mode
References: <528F7E8F.5050807@newflow.co.uk> <20131122163835.GF24508@pengutronix.de>
In-Reply-To: <20131122163835.GF24508@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/13 16:38, Michael Grzeschik wrote:
> Hallo,
> 
> On Fri, Nov 22, 2013 at 03:55:59PM +0000, Mark Jackson wrote:
>> The IDDIG input pin is normally used to determine the USB mode
>> (i.e. HOST or DEVICE).
>>
>> On some systems (e.g. AM335x) leaving this pin floating allows
>> the USB mode to be set via software.
>>
>> This patch adds support for this via the device tree.
>>
>> Signed-off-by: Mark Jackson <mpfj@newflow.co.uk>
>> ---
>>  .../devicetree/bindings/usb/am33xx-usb.txt         |    2 ++
>>  drivers/usb/musb/musb_dsps.c                       |   14 ++++++++++++++
>>  include/linux/usb/musb.h                           |    1 +
>>  3 files changed, 17 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/am33xx-usb.txt b/Documentation/devicetree/bindings/usb/am33xx-usb.txt
>> index 20c2ff2..560b7ff 100644
>> --- a/Documentation/devicetree/bindings/usb/am33xx-usb.txt
>> +++ b/Documentation/devicetree/bindings/usb/am33xx-usb.txt
>> @@ -47,6 +47,8 @@ USB
>>  - dmas: specifies the dma channels
>>  - dma-names: specifies the names of the channels. Use "rxN" for receive
>>    and "txN" for transmit endpoints. N specifies the endpoint number.
>> +- ti,force-host: specifies that the IDDIG input be ignored and the device be
>> +  put into host mode regardless.
> 
> You should always CC devicetree-discuss if adding new bindings. Why
> another binding anyway? We have the common binding dr_mode already.
> Please use this and of_usb_get_dr_mode from drivers/usb/usb-common.c
> instead.

Sure ... that's a nicer solution.

I'll do that for v2

Mark J.
