Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbaAWOfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:35:54 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:60980 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaAWOfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:35:51 -0500
MIME-Version: 1.0
In-Reply-To: <1390411440-1158-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1390411440-1158-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Thu, 23 Jan 2014 15:35:50 +0100
Message-ID: <CANq1E4S493v9t7PY5wOB=4YvNPgzwM9PrzcmK8g5XN1VeppQTg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] input/uinput: replace breaks by goto out in uinput_ioctl_handler
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin

On Wed, Jan 22, 2014 at 6:23 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> From: Benjamin Tisssoires <benjamin.tissoires@redhat.com>
>
> The current implementation prevents us to add variable-length ioctl.
> Use a bunch of gotos instead of break to allow us to do so.
>
> No functional changes.

Looks good.

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> Signed-off-by: Benjamin Tisssoires <benjamin.tissoires@redhat.com>
> ---
>
> changes since v3:
> - brand new patch :)
>
>  drivers/input/misc/uinput.c | 56 ++++++++++++++++++++++-----------------------
>  1 file changed, 27 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
> index 7728359..d8ae08d 100644
> --- a/drivers/input/misc/uinput.c
> +++ b/drivers/input/misc/uinput.c
> @@ -693,51 +693,51 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>         switch (cmd) {
>                 case UI_DEV_CREATE:
>                         retval = uinput_create_device(udev);
> -                       break;
> +                       goto out;
>
>                 case UI_DEV_DESTROY:
>                         uinput_destroy_device(udev);
> -                       break;
> +                       goto out;
>
>                 case UI_SET_EVBIT:
>                         retval = uinput_set_bit(arg, evbit, EV_MAX);
> -                       break;
> +                       goto out;
>
>                 case UI_SET_KEYBIT:
>                         retval = uinput_set_bit(arg, keybit, KEY_MAX);
> -                       break;
> +                       goto out;
>
>                 case UI_SET_RELBIT:
>                         retval = uinput_set_bit(arg, relbit, REL_MAX);
> -                       break;
> +                       goto out;
>
>                 case UI_SET_ABSBIT:
>                         retval = uinput_set_bit(arg, absbit, ABS_MAX);
> -                       break;
> +                       goto out;
>
>                 case UI_SET_MSCBIT:
>                         retval = uinput_set_bit(arg, mscbit, MSC_MAX);
> -                       break;
> +                       goto out;
>
>                 case UI_SET_LEDBIT:
>                         retval = uinput_set_bit(arg, ledbit, LED_MAX);
> -                       break;
> +                       goto out;
>
>                 case UI_SET_SNDBIT:
>                         retval = uinput_set_bit(arg, sndbit, SND_MAX);
> -                       break;
> +                       goto out;
>
>                 case UI_SET_FFBIT:
>                         retval = uinput_set_bit(arg, ffbit, FF_MAX);
> -                       break;
> +                       goto out;
>
>                 case UI_SET_SWBIT:
>                         retval = uinput_set_bit(arg, swbit, SW_MAX);
> -                       break;
> +                       goto out;
>
>                 case UI_SET_PROPBIT:
>                         retval = uinput_set_bit(arg, propbit, INPUT_PROP_MAX);
> -                       break;
> +                       goto out;
>
>                 case UI_SET_PHYS:
>                         if (udev->state == UIST_CREATED) {
> @@ -753,18 +753,18 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>
>                         kfree(udev->dev->phys);
>                         udev->dev->phys = phys;
> -                       break;
> +                       goto out;
>
>                 case UI_BEGIN_FF_UPLOAD:
>                         retval = uinput_ff_upload_from_user(p, &ff_up);
>                         if (retval)
> -                               break;
> +                               goto out;
>
>                         req = uinput_request_find(udev, ff_up.request_id);
>                         if (!req || req->code != UI_FF_UPLOAD ||
>                             !req->u.upload.effect) {
>                                 retval = -EINVAL;
> -                               break;
> +                               goto out;
>                         }
>
>                         ff_up.retval = 0;
> @@ -775,65 +775,63 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>                                 memset(&ff_up.old, 0, sizeof(struct ff_effect));
>
>                         retval = uinput_ff_upload_to_user(p, &ff_up);
> -                       break;
> +                       goto out;
>
>                 case UI_BEGIN_FF_ERASE:
>                         if (copy_from_user(&ff_erase, p, sizeof(ff_erase))) {
>                                 retval = -EFAULT;
> -                               break;
> +                               goto out;
>                         }
>
>                         req = uinput_request_find(udev, ff_erase.request_id);
>                         if (!req || req->code != UI_FF_ERASE) {
>                                 retval = -EINVAL;
> -                               break;
> +                               goto out;
>                         }
>
>                         ff_erase.retval = 0;
>                         ff_erase.effect_id = req->u.effect_id;
>                         if (copy_to_user(p, &ff_erase, sizeof(ff_erase))) {
>                                 retval = -EFAULT;
> -                               break;
> +                               goto out;
>                         }
>
> -                       break;
> +                       goto out;
>
>                 case UI_END_FF_UPLOAD:
>                         retval = uinput_ff_upload_from_user(p, &ff_up);
>                         if (retval)
> -                               break;
> +                               goto out;
>
>                         req = uinput_request_find(udev, ff_up.request_id);
>                         if (!req || req->code != UI_FF_UPLOAD ||
>                             !req->u.upload.effect) {
>                                 retval = -EINVAL;
> -                               break;
> +                               goto out;
>                         }
>
>                         req->retval = ff_up.retval;
>                         uinput_request_done(udev, req);
> -                       break;
> +                       goto out;
>
>                 case UI_END_FF_ERASE:
>                         if (copy_from_user(&ff_erase, p, sizeof(ff_erase))) {
>                                 retval = -EFAULT;
> -                               break;
> +                               goto out;
>                         }
>
>                         req = uinput_request_find(udev, ff_erase.request_id);
>                         if (!req || req->code != UI_FF_ERASE) {
>                                 retval = -EINVAL;
> -                               break;
> +                               goto out;
>                         }
>
>                         req->retval = ff_erase.retval;
>                         uinput_request_done(udev, req);
> -                       break;
> -
> -               default:
> -                       retval = -EINVAL;
> +                       goto out;
>         }
>
> +       retval = -EINVAL;
>   out:
>         mutex_unlock(&udev->mutex);
>         return retval;
> --
> 1.8.4.2
>
