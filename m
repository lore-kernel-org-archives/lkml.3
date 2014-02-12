Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaBLKje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:39:34 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:53967 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaBLKjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:39:31 -0500
MIME-Version: 1.0
In-Reply-To: <1392055139-19631-11-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
	<1392055139-19631-11-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 12 Feb 2014 11:39:31 +0100
Message-ID: <CANq1E4SrD5Qr6dgi5kTYJNkLyrb5y3X4R65ESfw2VtXvVG9G2A@mail.gmail.com>
Subject: Re: [PATCH 10/14] HID: wiimote: replace hid_output_raw_report with
 hid_hw_output_report for output requests
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Feb 10, 2014 at 6:58 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> For BT transport layer,
>   ret = hid_output_raw_report(A, B, C, HID_OUTPUT_REPORT);
> is equivalent to
>   ret = hid_hw_output_report(A, B, C);
>
> So use the new API where available

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/hid-wiimote-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hid/hid-wiimote-core.c b/drivers/hid/hid-wiimote-core.c
> index d7dc6c5b..d003914 100644
> --- a/drivers/hid/hid-wiimote-core.c
> +++ b/drivers/hid/hid-wiimote-core.c
> @@ -28,14 +28,14 @@ static int wiimote_hid_send(struct hid_device *hdev, __u8 *buffer,
>         __u8 *buf;
>         int ret;
>
> -       if (!hdev->hid_output_raw_report)
> +       if (!hdev->ll_driver->output_report)
>                 return -ENODEV;
>
>         buf = kmemdup(buffer, count, GFP_KERNEL);
>         if (!buf)
>                 return -ENOMEM;
>
> -       ret = hid_output_raw_report(hdev, buf, count, HID_OUTPUT_REPORT);
> +       ret = hid_hw_output_report(hdev, buf, count);
>
>         kfree(buf);
>         return ret;
> --
> 1.8.3.1
>
