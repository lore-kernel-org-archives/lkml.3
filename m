Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaKKGQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:16:08 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:45790 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaKKGQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:16:05 -0500
MIME-Version: 1.0
In-Reply-To: <bc2787a32b4d41a79acf582433831510@BN3PR0301MB1236.namprd03.prod.outlook.com>
References: <1414401857-21121-1-git-send-email-jingchang.lu@freescale.com>
 <CAGVrzcamoYbdPijWtrU=ge+UE+g9zBHAG84PJB7G3EyA09jBWg@mail.gmail.com>
 <20141111052720.GC24727@kroah.com> <bc2787a32b4d41a79acf582433831510@BN3PR0301MB1236.namprd03.prod.outlook.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 10 Nov 2014 22:15:23 -0800
Message-ID: <CAGVrzcb__HxFe3z9oM9WS7_ZnvCMkAsNt+FU6N4m-9Som-LJAw@mail.gmail.com>
Subject: Re: [RESENDv5] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
To: Jingchang Lu <jingchang.lu@freescale.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-10 21:41 GMT-08:00 Jingchang Lu <jingchang.lu@freescale.com>:
>
>
>>-----Original Message-----
>>From: Greg KH [mailto:gregkh@linuxfoundation.org]
>>Sent: Tuesday, November 11, 2014 1:27 PM
>>To: Florian Fainelli
>>Cc: Lu Jingchang-B35083; linux-arm-kernel@lists.infradead.org; linux-
>>kernel@vger.kernel.org; linux-serial@vger.kernel.org
>>Subject: Re: [RESENDv5] serial: of-serial: fix up PM ops on
>>no_console_suspend and port type
>>
>>On Mon, Nov 10, 2014 at 08:30:36PM -0800, Florian Fainelli wrote:
>>> 2014-10-27 2:24 GMT-07:00 Jingchang Lu <jingchang.lu@freescale.com>:
>>> > This patch fixes commit 2dea53bf57783f243c892e99c10c6921e956aa7e,
>>> > "serial: of-serial: add PM suspend/resume support", which disables
>>> > the uart clock on suspend, but also causes a hardware hang on
>>> > register access if no_console_suspend command line option is used.
>>> >
>>> > Also, not every of_serial device is an 8250 port, so the serial8250
>>> > suspend/resume functions should only be applied to a real 8250 port.
>>>
>>> Greg, can you pick this one and submit it for your next 3.18-rc
>>> submission? This fixes a regression when using "no_console_suspend"
>>> introduced by:
>>>
>>> 2dea53bf57783f243c892e99c10c6921e956aa7e ("serial: of-serial: add PM
>>> suspend/resume support") which has been merged during 3.18-rc1
>>
>>Why can't I just revert that patch instead?  This is really late in the -
>>rc cycle to be doing large fixes like this.
>>
>>And this patch is already queued up for 3.19-rc1, so this is a mess...
>>
>>Any objection to me just reverting
>>2dea53bf57783f243c892e99c10c6921e956aa7e, and then this one in my tty-next
>>branch as well, and then someone resending the original patch in a format
>>that actually works?
> Do you mean resending the "serial: of-serial: add PM suspend/resume support"
> patch with "serial: of-serial: fix up PM ops on no_console_suspend and port type"
> merged together? For you would like to reverting the previous patch of
> "2dea53bf57783f243c892e99c10c6921e956aa7e".

That is how I understand Greg's suggestion. While you are at it you
might want to introduce a space between the 'switch' keyword and the
open-parenthesis in the two call sites that you added. Feel free to
add my:

Tested-by: Florina Fainelli <f.fainelli@gmail.com>

since I use your v5 patch locally, thanks!
--
Florian
