Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaBLKRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:17:24 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:45403 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaBLKRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:17:20 -0500
MIME-Version: 1.0
In-Reply-To: <1392055139-19631-2-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
	<1392055139-19631-2-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 12 Feb 2014 11:17:20 +0100
Message-ID: <CANq1E4SFdvV0OCtd4bg6OX9wq0ZhF5fxG-eLj9XWByLsnJvMuw@mail.gmail.com>
Subject: Re: [PATCH 01/14] HID: uHID: remove duplicated code
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
> uhid_hid_output_report() can be implemented through a simple call
> to uhid_hid_output_raw().
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/uhid.c | 22 +---------------------
>  1 file changed, 1 insertion(+), 21 deletions(-)
>
> diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
> index 12439e1..b6de903 100644
> --- a/drivers/hid/uhid.c
> +++ b/drivers/hid/uhid.c
> @@ -247,27 +247,7 @@ static int uhid_hid_output_raw(struct hid_device *hid, __u8 *buf, size_t count,
>  static int uhid_hid_output_report(struct hid_device *hid, __u8 *buf,
>                                   size_t count)
>  {
> -       struct uhid_device *uhid = hid->driver_data;
> -       unsigned long flags;
> -       struct uhid_event *ev;
> -
> -       if (count < 1 || count > UHID_DATA_MAX)
> -               return -EINVAL;
> -
> -       ev = kzalloc(sizeof(*ev), GFP_KERNEL);
> -       if (!ev)
> -               return -ENOMEM;
> -
> -       ev->type = UHID_OUTPUT;
> -       ev->u.output.size = count;
> -       ev->u.output.rtype = UHID_OUTPUT_REPORT;
> -       memcpy(ev->u.output.data, buf, count);
> -
> -       spin_lock_irqsave(&uhid->qlock, flags);
> -       uhid_queue(uhid, ev);
> -       spin_unlock_irqrestore(&uhid->qlock, flags);
> -
> -       return count;
> +       return uhid_hid_output_raw(hid, buf, count, HID_OUTPUT_REPORT);

Took me a while to see that we have:
  HID_OUTPUT_REPORT
  UHID_OUTPUT_REPORT
.. gnah! I should have named the uhid stuff better.. anyhow, patch looks good:

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

>  }
>
>  static struct hid_ll_driver uhid_hid_driver = {
> --
> 1.8.3.1
>
