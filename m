Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaBLKNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:13:31 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:63039 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaBLKN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:13:27 -0500
MIME-Version: 1.0
In-Reply-To: <1391636004-29354-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1391636004-29354-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 12 Feb 2014 11:13:26 +0100
Message-ID: <CANq1E4RvavkaPvz8vozUvgOs6fSmYNR=2=sn76aFFCbR5caaBA@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] HID: spring cleanup v2
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Frank Praznik <frank.praznik@oh.rr.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Feb 5, 2014 at 10:33 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Hi guys,
>
> well, here comes the promised v2 of the ll_transport cleanup.
>
> As I said, I removed patches which need some more work, and kept only the
> trivial ones. I also added David's documentation, which gives us a net
> difference of +210 lines of code :(
> Let's say that we still have a net worth of -106 lines of actual code :)
>
> Cheers,
> Benjamin
>
> Changes since v1:
> - removed uhid, i2c-hid patches
> - removed the previous 11/11 (move hid_output_raw_report to hid_ll_driver)
> - hid-logitech-dj: use hid_hw_raw_request instead of hid_output_report (2/9)
> - add documentation - I removed the hid_input_event() doc (9/9)
>
> Benjamin Tissoires (9):
>   HID: add inliners for ll_driver transport-layer callbacks
>   HID: logitech-dj: remove hidinput_input_event

Apart from this logitech-dj patch, which I feel uncomfortable with
reviewing if I don't have the hardware, this series looks really good.
I think all patches already carry my r-b, otherwise feel free to add
them.

Thanks a lot for the cleanup!
David

>   HID: HIDp: remove hidp_hidinput_event
>   HID: remove hidinput_input_event handler
>   HID: HIDp: remove duplicated coded
>   HID: usbhid: remove duplicated code
>   HID: remove hid_get_raw_report in struct hid_device
>   HID: introduce helper to access hid_output_raw_report()
>   HID: Add HID transport driver documentation
>
>  Documentation/hid/hid-transport.txt | 316 ++++++++++++++++++++++++++++++++++++
>  drivers/hid/hid-input.c             |  12 +-
>  drivers/hid/hid-lg.c                |   6 +-
>  drivers/hid/hid-logitech-dj.c       | 106 +++++-------
>  drivers/hid/hid-magicmouse.c        |   2 +-
>  drivers/hid/hid-sony.c              |   9 +-
>  drivers/hid/hid-thingm.c            |   4 +-
>  drivers/hid/hid-wacom.c             |  16 +-
>  drivers/hid/hid-wiimote-core.c      |   2 +-
>  drivers/hid/hidraw.c                |   9 +-
>  drivers/hid/i2c-hid/i2c-hid.c       |   1 -
>  drivers/hid/uhid.c                  |   1 -
>  drivers/hid/usbhid/hid-core.c       |  65 ++------
>  include/linux/hid.h                 |  68 +++++++-
>  net/bluetooth/hidp/core.c           | 115 ++-----------
>  15 files changed, 471 insertions(+), 261 deletions(-)
>  create mode 100644 Documentation/hid/hid-transport.txt
>
> --
> 1.8.3.1
>
