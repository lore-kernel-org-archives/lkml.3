Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3BUKnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:43:05 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:51117 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3BUKnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:43:03 -0500
MIME-Version: 1.0
In-Reply-To: <1361265753-17541-1-git-send-email-mika.westerberg@linux.intel.com>
References: <51221AFD.1090108@ahsoftware.de>
	<1361265753-17541-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 21 Feb 2013 11:42:59 +0100
Message-ID: <CAN+gG=GqPzvD89rno1btJKACDo6E0KTJR3_JW9dOMFqR8DaoYg@mail.gmail.com>
Subject: Re: [PATCH] HID: make sensor autodetection independent of underlying bus
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alexander Holler <holler@ahsoftware.de>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        srinivas.pandruvada@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 10:22 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> Instead of limiting HID sensors to USB and I2C busses we can just make
> everything that has usage page of HID_UP_SENSOR to be included in
> HID_GROUP_SENSOR_HUB group. This allows the sensor-hub to work over
> bluetooth (and other transports) as well.
>
> Reported-by: Alexander Holler <holler@ahsoftware.de>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Reviewed-By: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

> ---
>  drivers/hid/hid-core.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index fe3a59e..f89e902 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -728,8 +728,7 @@ static int hid_scan_report(struct hid_device *hid)
>                 } else if (page == HID_UP_SENSOR &&
>                         item.type == HID_ITEM_TYPE_MAIN &&
>                         item.tag == HID_MAIN_ITEM_TAG_BEGIN_COLLECTION &&
> -                       (item_udata(&item) & 0xff) == HID_COLLECTION_PHYSICAL &&
> -                       (hid->bus == BUS_USB || hid->bus == BUS_I2C))
> +                       (item_udata(&item) & 0xff) == HID_COLLECTION_PHYSICAL)
>                         hid->group = HID_GROUP_SENSOR_HUB;
>         }
>
> --
> 1.7.10.4
>
