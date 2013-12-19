Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3LSQdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:33:43 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:48504 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab3LSQdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:33:41 -0500
MIME-Version: 1.0
In-Reply-To: <1387469113-4129-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1387469113-4129-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Thu, 19 Dec 2013 17:33:40 +0100
Message-ID: <CANq1E4QrPAJ7zNdN51PGQD5tkD_gTYfRoHOg7=zwVvnu-xOR0g@mail.gmail.com>
Subject: Re: [PATCH] HID: input: fix input sysfs path for hid devices
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

On Thu, Dec 19, 2013 at 5:05 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> we used to set the parent of the input device as the parent of
> the hid bus. This was introduced when we created hid as a real bus, and
> to keep backward compatibility. Now, it's time to proper set the parent
> so that sysfs has an idea of which input device is attached to
> which hid device.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>
> Hi Jiri,
>
> well, the regression test did not showed anything bad, and a look at the hid
> drivers also showed that no drivers should be armed by that.
>
> I think this is valuable because it will give a better understanding of the
> actual mapping hardware/inputs. Like a touchscreen with pen + touch will have
> the same hid parent, and I expect X/Wayland to be able to detect this at some
> point to keep the mapping correctly between the two input devices and the screen.
>
> I also need that for hid-replay, so that I can be sure which input is attached
> to which uhid device, and give up the heuristics I currently use.

I was just wondering where we have multiple HID devices on a single
parent, but yeah, uhid is a good example. I actually have no
objections to this patch and it looks fine. But I cannot tell whether
anyone relies on this.

I'd say we should give it a try.
David

> Cheers,
> Benjamin
>
>  drivers/hid/hid-input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index d97f232..d50e731 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -1279,7 +1279,7 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
>         input_dev->id.vendor  = hid->vendor;
>         input_dev->id.product = hid->product;
>         input_dev->id.version = hid->version;
> -       input_dev->dev.parent = hid->dev.parent;
> +       input_dev->dev.parent = &hid->dev;
>         hidinput->input = input_dev;
>         list_add_tail(&hidinput->list, &hid->inputs);
>
> --
> 1.8.3.1
>
