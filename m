Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaJTQrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:47:03 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64774 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaJTQrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:47:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+K2PTXWE7Fs6kNmdeWaw0y
Date: Mon, 20 Oct 2014 09:45:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        kishon@ti.com, s.nawrocki@samsung.com
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141020164542.GD5192@atomide.com>
References: <20141019090107.GA19132@amd>
 <201410191658.45851@pali>
 <20141019205033.GA4738@amd>
 <201410192300.20625@pali>
 <20141020130855.GA1067@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020130855.GA1067@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [141020 06:10]:
> Hi!
> 
> > My N900 can boot kernel from v3.12-rc5-n900 branch compiled with 
> > arch/arm/configs/rx51_defconfig. Also it can boot full Maemo5 
> > system (with CSSU and some minor system changes) and usb network 
> > via g_nokia.ko gadget working fine...
> > 
> > So if it does not working for you then kernel usb subsystem could 
> > have problems with using gadgets directly from zimage.
> 
> After some hand-bisecting and real-bisecting, I found two commits that
> cause problems for 3.13: With these reverted, I get usb networking
> back in 3.13 on nokia n900.
> 
> (Pali, if you revert these, you should get working usb networking in
> your 3.13 branch, too.)
> 
> Any ideas?

Hmm maybe check if current stable kernels work for you without
reverting anything ? Few weeks ago I did the the following two fixes
with cc stable v3.13+:

96be39ab34b7 usb: phy: twl4030-usb: Fix regressions to runtime PM on omaps
85601b8d81e2 usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down

Regards,

Tony 
