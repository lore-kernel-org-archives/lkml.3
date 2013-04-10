Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765597Ab3DJAJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:09:37 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:35012 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762270Ab3DJAJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:09:35 -0400
MIME-Version: 1.0
In-Reply-To: <1365501657-4213-8-git-send-email-serban.constantinescu@arm.com>
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com>
	<1365501657-4213-8-git-send-email-serban.constantinescu@arm.com>
Date: Tue, 9 Apr 2013 17:09:35 -0700
Message-ID: <CAMP5Xgf+hAyo+W17zMfcdSk6+PaK+eHho_Dz=XphbojE=JGA8Q@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] staging: android: binder: replace types with
 portable ones
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 3:00 AM, Serban Constantinescu
<serban.constantinescu@arm.com> wrote:
> Since this driver is meant to be used on different types of processors
> and a portable driver should specify the size a variable expects to be
> this patch changes the types used throughout the binder interface.
>
> We use "userspace" types since this header will be exported and used by
> the Android filesystem.
>
> The patch does not change in any way the functionality of the binder driver.
>
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> ---
>  drivers/staging/android/binder.h |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
> index 8789baa..f3ffacd 100644
> --- a/drivers/staging/android/binder.h
> +++ b/drivers/staging/android/binder.h
> @@ -123,10 +123,10 @@ struct binder_transaction_data {
>                 void    *ptr;   /* target descriptor of return transaction */
>         } target;
>         void            *cookie;        /* target object cookie */
> -       unsigned int    code;           /* transaction command */
> +       __u32           code;           /* transaction command */
>
>         /* General information about the transaction. */
> -       unsigned int    flags;
> +       __u32           flags;
>         pid_t           sender_pid;
>         uid_t           sender_euid;
>         size_t          data_size;      /* number of bytes of data */
> @@ -143,7 +143,7 @@ struct binder_transaction_data {
>                         /* offsets from buffer to flat_binder_object structs */
>                         const void __user       *offsets;
>                 } ptr;
> -               uint8_t buf[8];
> +               __u8    buf[8];
>         } data;
>  };
>
> @@ -153,18 +153,18 @@ struct binder_ptr_cookie {
>  };
>
>  struct binder_pri_desc {
> -       int priority;
> -       int desc;
> +       __s32 priority;
> +       __s32 desc;
>  };
>
>  struct binder_pri_ptr_cookie {
> -       int priority;
> +       __s32 priority;
>         void *ptr;
>         void *cookie;
>  };
>
>  enum binder_driver_return_protocol {
> -       BR_ERROR = _IOR('r', 0, int),
> +       BR_ERROR = _IOR('r', 0, __s32),
>         /*
>          * int: error code
>          */
> @@ -178,7 +178,7 @@ enum binder_driver_return_protocol {
>          * binder_transaction_data: the received command.
>          */
>
> -       BR_ACQUIRE_RESULT = _IOR('r', 4, int),
> +       BR_ACQUIRE_RESULT = _IOR('r', 4, __s32),
>         /*
>          * not currently supported
>          * int: 0 if the last bcATTEMPT_ACQUIRE was not successful.
> @@ -258,7 +258,7 @@ enum binder_driver_command_protocol {
>          * binder_transaction_data: the sent command.
>          */
>
> -       BC_ACQUIRE_RESULT = _IOW('c', 2, int),
> +       BC_ACQUIRE_RESULT = _IOW('c', 2, __s32),
>         /*
>          * not currently supported
>          * int:  0 if the last BR_ATTEMPT_ACQUIRE was not successful.
> @@ -270,10 +270,10 @@ enum binder_driver_command_protocol {
>          * void *: ptr to transaction data received on a read
>          */
>
> -       BC_INCREFS = _IOW('c', 4, int),
> -       BC_ACQUIRE = _IOW('c', 5, int),
> -       BC_RELEASE = _IOW('c', 6, int),
> -       BC_DECREFS = _IOW('c', 7, int),
> +       BC_INCREFS = _IOW('c', 4, __s32),
> +       BC_ACQUIRE = _IOW('c', 5, __s32),
> +       BC_RELEASE = _IOW('c', 6, __s32),
> +       BC_DECREFS = _IOW('c', 7, __s32),

These four are actually read as unsigned values, so it would be better
to use __u32 here.

>         /*
>          * int: descriptor
>          */
> --
> 1.7.9.5
>



--
Arve Hjønnevåg
