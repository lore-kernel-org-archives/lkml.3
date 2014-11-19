Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaKSPcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:32:24 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:41641 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbaKSPcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:32:22 -0500
MIME-Version: 1.0
In-Reply-To: <20141114222640.GA39748@dtor-ws>
References: <20141114222640.GA39748@dtor-ws>
Date: Wed, 19 Nov 2014 10:32:20 -0500
Message-ID: <CAN+gG=FaovQETa3+qQsLoBBQnbZ8Q2uoQJD6_XvAmCCvGTHT1g@mail.gmail.com>
Subject: Re: [git pull] Input updates for 3.18-rc4
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Ulrik De Bie <ulrik.debie-os@e2big.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulrik,


On Fri, Nov 14, 2014 at 5:26 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Linus,
>
> Please pull from:
>
>         git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> or
>         master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
>
> to receive updates for the input subsystem. Mostly small fixups to PS/2
> tochpad drivers (ALPS, Elantech, Synaptics) to better deal with specific
> hardware.
>
> Changelog:
> ---------
>
> NeilBrown (1):
>       Input: twl4030-pwrbutton - ensure a wakeup event is recorded.
>
> Pali Rohár (3):
>       Input: alps - ignore potential bare packets when device is out of sync
>       Input: alps - allow up to 2 invalid packets without resetting device
>       Input: alps - ignore bad data on Dell Latitudes E6440 and E7440
>
> Takashi Iwai (1):
>       Input: synaptics - add min/max quirk for Lenovo T440s
>
> Ulrik De Bie (5):
>       Input: elantech - use elantech_report_trackpoint for hardware v4 too
>       Input: elantech - fix crc_enabled for Fujitsu H730
>       Input: elantech - report the middle button of the touchpad
>       Input: elantech - provide a sysfs knob for crc_enabled
>       Input: elantech - update the documentation

It looks like this elantech changes raise some warnings on a Samsung
laptop. Can you have a look please?
https://bugzilla.redhat.com/show_bug.cgi?id=1165390

Hans and myself are in CC of the bug report, we can ask further
details to the reporter if requested.

Cheers,
Benjamin

>
>
> Diffstat:
> --------
>
>  Documentation/input/elantech.txt       | 81 +++++++++++++++++++++++++++++++---
>  drivers/input/misc/twl4030-pwrbutton.c |  1 +
>  drivers/input/mouse/alps.c             | 28 +++++++++++-
>  drivers/input/mouse/elantech.c         | 56 +++++++++++++++++++++--
>  drivers/input/mouse/synaptics.c        |  5 ++-
>  5 files changed, 158 insertions(+), 13 deletions(-)
>
> --
> Dmitry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
