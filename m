Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab3KVLgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 06:36:15 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50026 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064Ab3KVLgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 06:36:11 -0500
X-Sasl-enc: QPQBLPvwfXDPfl7hmDf8x/fye1jKQg2qAZl8Udk4clok 1385120163
Date: Fri, 22 Nov 2013 09:36:01 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Kyungmin Park'" <kmpark@infradead.org>,
        "'Henrique de Moraes Holschuh'" <ibm-acpi@hmh.eng.br>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kay@vrfy.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] video: backlight: Remove backlight sysfs uevent
Message-ID: <20131122113601.GB27196@khazad-dum.debian.net>
References: <20131111235700.GA29987@july>
 <002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
 <20131112005628.GA2914@khazad-dum.debian.net>
 <1384990859.20536.4.camel@x230>
 <20131121114332.GA23710@khazad-dum.debian.net>
 <20131121143326.GA19773@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121143326.GA19773@srcf.ucam.org>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013, Matthew Garrett wrote:
> On Thu, Nov 21, 2013 at 09:43:32AM -0200, Henrique de Moraes Holschuh wrote:
> > With this patchset applied, as far as I can tell anything that used to be
> > uevent-driven by the backlight class will break: when a process changes the
> > backlight using sysfs, other processes will not be notified of the change
> > anymore.  This patchset seems to break backlight uevent support in such a
> > way that basically renders the entire thing useless and you might as well
> > just remove uevent support entirely.
> 
> The uevent support was initially added to handle systems where pressing 
> a hotkey generates an event (good) but the firmware automatically 
> changes the brightness (bad). I have absolutely no idea why I added 
> BACKLIGHT_UPDATE_SYSFS - BACKLIGHT_UPDATE_HOTKEY solves the problem I 
> was trying to solve. I'm not aware of any userspace that relies on 
> BACKLIGHT_UPDATE_SYSFS.

Well, either we have userspace that rely on the uevents, or we don't. 

If we don't have any uevent users of the backlight notifications, we might
as well just rip out the feature entirely and replace it with something with
a proper design.  But that would mean all OSD is being done by time-based
open-read-close polling of sysfs or keyed to input events (and therefore
half-baked).

However, if we do have anything that rely on the uevents, it needs
BACKLIGHT_UPDATE_SYSFS.  Without it, there will be no notifications when the
backlight level is changed through sysfs.  And we *DO* have applications
that change the backlight level through sysfs.  From the top of my head, I
know KDE does when it starts, and also as a response to power management
events.  Also, userspace hotkey daemons do use the sysfs interface.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
