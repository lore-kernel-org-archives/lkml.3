Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaBWNDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 08:03:43 -0500
Received: from mail.wdtv.com ([66.118.69.84]:41668 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaBWNDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 08:03:42 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Mike Galbraith <bitbucket@online.de>
Subject: Re: It BOOTS! 3.13.5 that is.
Date: Sun, 23 Feb 2014 08:03:30 -0500
Cc: Ilia Mirkin <imirkin@alum.mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201402222022.20370.gheskett@wdtv.com> <201402230018.34029.gheskett@wdtv.com> <1393135859.30960.8.camel@marge.simpson.net>
In-Reply-To: <1393135859.30960.8.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402230803.31091.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 February 2014, Mike Galbraith wrote:
>On Sun, 2014-02-23 at 00:18 -0500, Gene Heskett wrote:
>> On Saturday 22 February 2014, Ilia Mirkin wrote:
>> 
>> Sorry, no such beast As VIDEO_CX88.
>> 
>> Now that tells me something in the VIDEO dept isn't set, but what?
>
>Beast radar:
>find drivers -name Kconfig -exec grep -C5 VIDEO_CX88 {} \;
>
>Blip:
>config VIDEO_CX88
>        tristate "Conexant 2388x (bt878 successor) support"
>        depends on VIDEO_DEV && PCI && I2C && RC_CORE  <=== IFF signature
>        select I2C_ALGOBIT
>        select VIDEO_BTCX
>        select VIDEOBUF_DMA_SG
>--
>          TV cards.
>
>          To compile this driver as a module, choose M here: the
>          module will be called cx8800

That part I think (thats probably a bad thing) that because I didn't have 
SIMPLE_TUNER enabled, which I see is but its not working in this old boot 
either, but its at least seen, but there is no evidence that 
/lib/firmware/dvb-fe-or51132-vsb.fw is being loaded even in this old boot.

The instructions are ambiguous at best in the make xconfig help screen:

Oren OR51132 based (DVB_OR51132)

CONFIG_DVB_OR51132:

An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
to support this frontend.

This driver needs external firmware. Please use the commands
"<kerneldir>/Documentation/dvb/get_dvb_firmware or51132_vsb" and/or
"<kerneldir>/Documentation/dvb/get_dvb_firmware or51132_qam" to
download firmwares for 8VSB and QAM64/256, respectively. Copy them to
/usr/lib/hotplug/firmware or /lib/firmware (depending on
configuration of firmware hotplug).

Symbol: DVB_OR51132 [=m]
Type : tristate
Prompt: Oren OR51132 based
-------------------
That file looks like the download and strip script to put those 2 files
into /lib/firmware, and both of those firmwares are present in 
/lib/firmware, but how they actually get loaded is _not_ at all clear.

There is in this machine, a /usr/lib/hotplug/firmware tree also, were these 
files miss-placed?  I can put copies both places I guess.  Actually, they 
were simlinks, and that was missing, so I made one.  Reboot again after 
adding simple_tuner.




Thanks Mike, Ilia.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

