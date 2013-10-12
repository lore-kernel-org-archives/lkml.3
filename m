Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3JLQU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 12:20:29 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55121 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab3JLQU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 12:20:27 -0400
Message-ID: <52598494.5020108@cogentembedded.com>
Date: Sat, 12 Oct 2013 19:19:16 +0200
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matthias Beyer <mail@beyermatthias.de>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: usb: core: devio.c: Coding style fixes
References: <1381441292-6145-5-git-send-email-mail@beyermatthias.de> <1381575694-9886-1-git-send-email-mail@beyermatthias.de>
In-Reply-To: <1381575694-9886-1-git-send-email-mail@beyermatthias.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12-10-2013 13:01, Matthias Beyer wrote:

> Whitespace fixes, including:

> - Whitespace after if-keyword
> - Spaces to Tabs

> Other coding style fixes:

> - Added braces for if-else blocks where missing

> Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
> ---
>   drivers/usb/core/devio.c | 40 +++++++++++++++++++++-------------------
>   1 file changed, 21 insertions(+), 19 deletions(-)

> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 71dc5d7..5f8a40d 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
[...]
> @@ -1636,32 +1636,32 @@ static int proc_reapurbnonblock(struct dev_state *ps, void __user *arg)
>   static int proc_control_compat(struct dev_state *ps,
>   				struct usbdevfs_ctrltransfer32 __user *p32)
>   {
> -        struct usbdevfs_ctrltransfer __user *p;
> -        __u32 udata;
> -        p = compat_alloc_user_space(sizeof(*p));
> -        if (copy_in_user(p, p32, (sizeof(*p32) - sizeof(compat_caddr_t))) ||
> -            get_user(udata, &p32->data) ||
> +	struct usbdevfs_ctrltransfer __user *p;
> +	__u32 udata;

    Could you also add an empty line here, for consistency with the below code?

> +	p = compat_alloc_user_space(sizeof(*p));
> +	if (copy_in_user(p, p32, (sizeof(*p32) - sizeof(compat_caddr_t))) ||
> +	    get_user(udata, &p32->data) ||
>   	    put_user(compat_ptr(udata), &p->data))
>   		return -EFAULT;
> -        return proc_control(ps, p);
> +	return proc_control(ps, p);
>   }
>
>   static int proc_bulk_compat(struct dev_state *ps,
>   			struct usbdevfs_bulktransfer32 __user *p32)
>   {
> -        struct usbdevfs_bulktransfer __user *p;
> -        compat_uint_t n;
> -        compat_caddr_t addr;
> +	struct usbdevfs_bulktransfer __user *p;
> +	compat_uint_t n;
> +	compat_caddr_t addr;
>
> -        p = compat_alloc_user_space(sizeof(*p));
> +	p = compat_alloc_user_space(sizeof(*p));
>
> -        if (get_user(n, &p32->ep) || put_user(n, &p->ep) ||
> -            get_user(n, &p32->len) || put_user(n, &p->len) ||
> -            get_user(n, &p32->timeout) || put_user(n, &p->timeout) ||
> -            get_user(addr, &p32->data) || put_user(compat_ptr(addr), &p->data))
> -                return -EFAULT;
> +	if (get_user(n, &p32->ep) || put_user(n, &p->ep) ||
> +	    get_user(n, &p32->len) || put_user(n, &p->len) ||
> +	    get_user(n, &p32->timeout) || put_user(n, &p->timeout) ||
> +	    get_user(addr, &p32->data) || put_user(compat_ptr(addr), &p->data))
> +		return -EFAULT;
>
> -        return proc_bulk(ps, p);
> +	return proc_bulk(ps, p);
>   }
>   static int proc_disconnectsignal_compat(struct dev_state *ps, void __user *arg)
>   {
> @@ -1838,10 +1838,12 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
>   		return -ENODEV;
>   	}
>
> -	if (ps->dev->state != USB_STATE_CONFIGURED)
> +	if (ps->dev->state != USB_STATE_CONFIGURED) {
>   		retval = -EHOSTUNREACH;
> -	else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno)))
> +	}
> +	else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno))) {

    No, } and *else* should be on the same line. But wait, both arms of *if* 
are single statements, so why you added {} in the first place? :-/

>   		retval = -EINVAL;
> +	}

WBR, Sergei

