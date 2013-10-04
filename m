Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3JDCsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 22:48:50 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39337 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3JDCst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 22:48:49 -0400
MIME-Version: 1.0
In-Reply-To: <1380839467-27264-1-git-send-email-pingc@wacom.com>
References: <1380839467-27264-1-git-send-email-pingc@wacom.com>
Date: Thu, 3 Oct 2013 21:48:48 -0500
Message-ID: <CAGzDe_bMe8h6R+VHgbmXvtK+mN63-+wNu3c_JgSLZiWFcW3Hrg@mail.gmail.com>
Subject: Re: [PATCH] input - input.h: Add a new switch event
From: Chris Bagwell <chris@cnpbagwell.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ping Cheng <pingc@wacom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 5:31 PM, Ping Cheng <pinglinux@gmail.com> wrote:
> One of Wacom's pen and touch capable models added a switch for
> users to turn on/off touch events. We need to report the state of
> this switch to userland. But, there is no existing switch event
> defined for this purpose. Luckily enough, there is a room for a
> new switch event.

It is a switch so hard to argue against adding it this way... but I
also want to point out existing feature to consider.

Touchpads on several laptops have either a single touchpad toggle
button or a touchpad switch that serve same basic purpose.  Most of
these switches are hooked up as keys and controlled by platform/x86
driver or udev.

Most platform/x86 drivers map these "keys" to KEY_TOUCHPAD_TOGGLE,
KEY_TOUCHPAD_ON, and KEY_TOUCHPAD_OFF.  Since those don't make it to
X, most udev keymaps instead use f21, f22, and f23 for same purpose.

As long as this is a touch+tablet that looks like a touchpad then
using those keys will cause gnome-settings-daemon to give a nice OSD
touchpad status when switch is moved and will also enable/disable the
touchpad using "Device Enabled" X property.

On the down side, I think these keys are treated as system wide
disable of all touchpads.  Having a Switch reported against the device
its controlling (as apposed to above which is reported over different
input then touchpad) would allow user land an easy way to know to only
disable the single device.

Chris

>
> Signed-off-by: Ping Cheng <pingc@wacom.com>
> ---
>  include/uapi/linux/input.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> index d08abf9..d4097b0 100644
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -855,6 +855,7 @@ struct input_keymap_entry {
>  #define SW_FRONT_PROXIMITY     0x0b  /* set = front proximity sensor active */
>  #define SW_ROTATE_LOCK         0x0c  /* set = rotate locked/disabled */
>  #define SW_LINEIN_INSERT       0x0d  /* set = inserted */
> +#define SW_TOUCH_ENABLED       0x0e  /* set = touch switch turned on (touch events off) */
>  #define SW_MAX                 0x0f
>  #define SW_CNT                 (SW_MAX+1)
>
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
