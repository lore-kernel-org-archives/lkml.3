Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3KXDxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 22:53:18 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46751 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190Ab3KXDxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 22:53:14 -0500
X-Sasl-enc: 7Eh/Mt1+BrGxzYcyyk/XGi0LC3Z0+D2pM/5pnsswUy+q 1385265193
Date: Sun, 24 Nov 2013 01:53:11 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-fbdev@vger.kernel.org, "'Kyungmin Park'" <kmpark@infradead.org>,
        kay@vrfy.org, Jingoo Han <jg1.han@samsung.com>,
        "'Henrique de Moraes Holschuh'" <ibm-acpi@hmh.eng.br>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [ibm-acpi-devel] [PATCH] video: backlight: Remove backlight
 sysfs uevent
Message-ID: <20131124035311.GC19499@khazad-dum.debian.net>
References: <20131111235700.GA29987@july>
 <002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
 <20131112005628.GA2914@khazad-dum.debian.net>
 <1384990859.20536.4.camel@x230>
 <20131121114332.GA23710@khazad-dum.debian.net>
 <20131121143326.GA19773@srcf.ucam.org>
 <20131122113601.GB27196@khazad-dum.debian.net>
 <20131122171556.GA15680@srcf.ucam.org>
 <20131124004015.GA19499@khazad-dum.debian.net>
 <20131124010257.GA6376@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131124010257.GA6376@srcf.ucam.org>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Nov 2013, Matthew Garrett wrote:
> On Sat, Nov 23, 2013 at 10:40:15PM -0200, Henrique de Moraes Holschuh wrote:
> > On Fri, 22 Nov 2013, Matthew Garrett wrote:
> > > We have userspace that relies on uevents of type 
> > > BACKLIGHT_UPDATE_HOTKEY. I don't know that we have userspace that relies 
> > > on uevents of type BACKLIGHT_UPDATE_SYSFS.
> > 
> > Any OSD application would have to rely on both uevent types, or it is broken
> > (and to test that, just write a level to sysfs and watch the OSD app fail to
> > tell you about the backlight level change...)
> 
> Right, OSDs are supposed to respond to keypresses, not arbitrary changes 
> of backlight. If the user's just echoed 8 into brightness, they know 
> they set the brightness to 8 - they don't need an OSD to tell them that. 

It is not just the user that sets the brightness.

Still, if you're sure that all userspace users react only to the hotkey type
of event, removing the sysfs one won't break anything any further.

But it will be *really* annoying the day we revisit this because someone
started abusing the hotkey uevent and we have to deploy a proper fix (rate
limiting or switching to a proper event report interface that doesn't use
uevents).

> BACKLIGHT_UPDATE_HOTKEY is when the firmware itself has changed the 
> brightness in response to a keypress, and so reporting the keypress 
> would result in additional backlight changes.

Yeah, I know that bug quite well, thinkpads were the first victims of
idiotic feedback event loops caused by braindead userspace.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
