Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbaGCJhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:37:38 -0400
Received: from aso-006-i446.relay.mailchannels.net ([23.91.64.127]:30080 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758558AbaGCJhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:37:34 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2014 05:37:33 EDT
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-MC-Relay: Good
X-MailChannels-SenderId: arvixe|x-authuser|przemo@firszt.eu
X-MailChannels-Auth-Id: arvixe
Date: Thu, 03 Jul 2014 09:21:43 +0000
Message-ID: <20140703092143.Horde.pRrZTs1B-ZEo6Oax4ouKOw1@webmail.firszt.eu>
From: Przemo Firszt <przemo@firszt.eu>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linuxwacom-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [Linuxwacom-devel] [PATCH 06/15] Input - wacom: install
 LED/OLED sysfs files in the HID device instead of USB
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
 <1404163586-29582-7-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1404163586-29582-7-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Internet Messaging Program (IMP) H5 (6.1.4)
Accept-Language: en,pl
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-AuthUser: przemo@firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Benjamin Tissoires <benjamin.tissoires@redhat.com>:

> Removes one more dependency over USB, but requires some changes in
> the user space to find the sysfs files correctly.
>
> This patch breaks the user space. However, the number of program
> accessing the LEDs is quite limited and we can easily patch them
> to handle the new HID behavior.
[..]
Hi Bejnamin,
If you get the green light to break the user space we might as well  
think about getting it in line with led/oled over bluetooth (intuos4  
wireless) or the other way around.

The biggest user of led/oled functionality is gnome and there are also  
a few small projects that would stop working after that change. I can  
fix i4oled project easily, i4oled-gui is based on gnome handling oleds.

Patching those 2 should be enough to fix gnome:
https://git.gnome.org/browse/gnome-settings-daemon/tree/plugins/wacom/gsd-wacom-led-helper.c
https://git.gnome.org/browse/gnome-settings-daemon/tree/plugins/wacom/gsd-wacom-oled-helper.c

Regards,
Przemo Firszt


