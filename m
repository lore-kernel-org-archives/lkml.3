Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab3KMRMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:12:55 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44681 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293Ab3KMRMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:12:46 -0500
Message-Id: <1384362765.13620.47030097.09D237AE@webmail.messagingengine.com>
X-Sasl-Enc: 98rTm5oJ+mUTEjME08jtfF1z2U+a4o7lsdTgSypQXl6P 1384362765
From: randmedia@123mail.org
To: Jim Bos <jim876@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-d4893488
In-Reply-To: <5283AE49.6030302@xs4all.nl>
References: <1384360284.28215.47013129.162FF17C@webmail.messagingengine.com>
 <5283AE49.6030302@xs4all.nl>
Subject: Re: How to correctly disable LIRC-related MCE*/IR_* modules,
 to remove ID of RemoteControl as BOTH keyboard & remote?
Date: Wed, 13 Nov 2013 09:12:45 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

On Wed, Nov 13, 2013, at 08:52 AM, Jim Bos wrote:
> Have you looked at this sysfs-file, specifically tried this:
> 
> echo lirc > /sys/class/rc/rc0/protocols

In short, yes.

atm, I've this udev rule,

	cat /etc/udev/rules.d/70-infrared.rules
		ACTION=="add", SUBSYSTEM=="rc",
		RUN+="/usr/bin/ir-keytable --clear --protocol=LIRC
		--write=/etc/rc_keymaps/my_streamzap_rpi"

which ensures after boot

	ir-keytable
	Found /sys/class/rc/rc0/ (/dev/input/event2) with:
	        Driver streamzap, table rc-streamzap
	        Supported protocols: LIRC 
	        Enabled protocols: LIRC 
	        Repeat delay = 500 ms, repeat period = 125 ms

which correlates to

	cat  /sys/class/rc/rc0/protocols 
		[lirc]

i.e., the same effect as the manual intervetion of

	echo lirc > /sys/class/rc/rc0/protocols

nonetheless, that _alone_, does NOT 'do the trick'.  if those MCE*
kernel mods are around, i.e., if I have NOT disabled them in the kernel
(re)compile, or, similarly, use the distro-provided kernel which
compiles the mods by default, then -- at boot -- the Streamzap is
recognized/assigned as an MCE keyboard/remote.

rand
