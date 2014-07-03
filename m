Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbaGCNq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbaGCNq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:46:27 -0400
Date: Thu, 3 Jul 2014 09:45:47 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: linuxwacom-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [Linuxwacom-devel] [PATCH 06/15] Input - wacom: install LED/OLED
 sysfs files in the HID device instead of USB
Message-ID: <20140703134547.GA6706@mail.corp.redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
 <1404163586-29582-7-git-send-email-benjamin.tissoires@redhat.com>
 <20140703092143.Horde.pRrZTs1B-ZEo6Oax4ouKOw1@webmail.firszt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140703092143.Horde.pRrZTs1B-ZEo6Oax4ouKOw1@webmail.firszt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Przemo,

On Jul 03 2014 or thereabouts, Przemo Firszt wrote:
> 
> Quoting Benjamin Tissoires <benjamin.tissoires@redhat.com>:
> 
> >Removes one more dependency over USB, but requires some changes in
> >the user space to find the sysfs files correctly.
> >
> >This patch breaks the user space. However, the number of program
> >accessing the LEDs is quite limited and we can easily patch them
> >to handle the new HID behavior.
> [..]
> Hi Bejnamin,
> If you get the green light to break the user space we might as well think
> about getting it in line with led/oled over bluetooth (intuos4 wireless) or
> the other way around.

I think it would be easier to fix the bluetooth (current hid) driver. I
think you already implemented the bluetooth handling in gnome 3.12 and
3.13, but having an uniform way of accessing the LEDs/OLEDs would be
nice.

> 
> The biggest user of led/oled functionality is gnome and there are also a few
> small projects that would stop working after that change. I can fix i4oled
> project easily, i4oled-gui is based on gnome handling oleds.

I tried i4oled-gui last week or so, and patching g-s-d was enough. That
was a good idea to rely on gnome internals for your tool :)

> 
> Patching those 2 should be enough to fix gnome:
> https://git.gnome.org/browse/gnome-settings-daemon/tree/plugins/wacom/gsd-wacom-led-helper.c
> https://git.gnome.org/browse/gnome-settings-daemon/tree/plugins/wacom/gsd-wacom-oled-helper.c

Yes, those two are sufficient enough. I had to make the patches
(http://paste.fedoraproject.org/115318/14043949/) so I could test that nothing
was broken. I'll submit those as soon as the fate of this conversion is
decided.

The current libwacom code also need a fix to handle the hid devices
(bluetooth and this series), and I have to send it for a while now :(

Cheers,
Benjamin

