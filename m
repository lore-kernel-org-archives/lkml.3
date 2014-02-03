Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaBCQKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:10:42 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:58813 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaBCQKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:10:40 -0500
MIME-Version: 1.0
In-Reply-To: <1391316630-29541-7-git-send-email-benjamin.tissoires@redhat.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
	<1391316630-29541-7-git-send-email-benjamin.tissoires@redhat.com>
Date: Mon, 3 Feb 2014 17:10:39 +0100
Message-ID: <CANq1E4TK6-9=FroLDPqV8D6o358ruizF_D3CfG3cpLx9_gOYzw@mail.gmail.com>
Subject: Re: [PATCH 06/11] HID: remove hidinput_input_event handler
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

On Sun, Feb 2, 2014 at 5:50 AM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> All the different transport drivers use now the generic event handling
> in hid-input. We can remove the handler definitively now.

\o/

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/hid-input.c | 4 +---
>  include/linux/hid.h     | 4 ----
>  2 files changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index a713e62..594722d 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -1263,9 +1263,7 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
>         }
>
>         input_set_drvdata(input_dev, hid);
> -       if (hid->ll_driver->hidinput_input_event)
> -               input_dev->event = hid->ll_driver->hidinput_input_event;
> -       else if (hid->ll_driver->request || hid->hid_output_raw_report)
> +       if (hid->ll_driver->request || hid->hid_output_raw_report)
>                 input_dev->event = hidinput_input_event;
>         input_dev->open = hidinput_open;
>         input_dev->close = hidinput_close;
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index dddcad0..38c307b 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -675,7 +675,6 @@ struct hid_driver {
>   * @stop: called on remove
>   * @open: called by input layer on open
>   * @close: called by input layer on close
> - * @hidinput_input_event: event input event (e.g. ff or leds)
>   * @parse: this method is called only once to parse the device data,
>   *        shouldn't allocate anything to not leak memory
>   * @request: send report request to device (e.g. feature report)
> @@ -693,9 +692,6 @@ struct hid_ll_driver {
>
>         int (*power)(struct hid_device *hdev, int level);
>
> -       int (*hidinput_input_event) (struct input_dev *idev, unsigned int type,
> -                       unsigned int code, int value);
> -
>         int (*parse)(struct hid_device *hdev);
>
>         void (*request)(struct hid_device *hdev,
> --
> 1.8.3.1
>
