Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176Ab3DJARs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:17:48 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42525 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765229Ab3DJARr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:17:47 -0400
MIME-Version: 1.0
In-Reply-To: <1365501657-4213-3-git-send-email-serban.constantinescu@arm.com>
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com>
	<1365501657-4213-3-git-send-email-serban.constantinescu@arm.com>
Date: Tue, 9 Apr 2013 17:17:46 -0700
Message-ID: <CAMP5XgfRqJaNbQWgdDyWeR+dg+RzU7+NRBav9kwQ6L3cj4dx8Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] staging: android: binder: replace IOCTL types with
 user-exportable types
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
> This patch modifies the IOCTL macros to use user-exportable data types,
> as they are the referred kernel types for the user/kernel interface.
>
> The patch does not change in any way the functionality of the binder driver.
>
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>

Acked-by: Arve Hjønnevåg <arve@android.com>

> ---
>  drivers/staging/android/binder.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
> index f240464..dbe81ce 100644
> --- a/drivers/staging/android/binder.h
> +++ b/drivers/staging/android/binder.h
> @@ -85,11 +85,11 @@ struct binder_version {
>  #define BINDER_CURRENT_PROTOCOL_VERSION 7
>
>  #define BINDER_WRITE_READ              _IOWR('b', 1, struct binder_write_read)
> -#define        BINDER_SET_IDLE_TIMEOUT         _IOW('b', 3, int64_t)
> +#define        BINDER_SET_IDLE_TIMEOUT         _IOW('b', 3, __s64)
>  #define        BINDER_SET_MAX_THREADS          _IOW('b', 5, size_t)
> -#define        BINDER_SET_IDLE_PRIORITY        _IOW('b', 6, int)
> -#define        BINDER_SET_CONTEXT_MGR          _IOW('b', 7, int)
> -#define        BINDER_THREAD_EXIT              _IOW('b', 8, int)
> +#define        BINDER_SET_IDLE_PRIORITY        _IOW('b', 6, __s32)
> +#define        BINDER_SET_CONTEXT_MGR          _IOW('b', 7, __s32)
> +#define        BINDER_THREAD_EXIT              _IOW('b', 8, __s32)

BINDER_SET_CONTEXT_MGR and BINDER_THREAD_EXIT don't actually take an argument.

>  #define BINDER_VERSION                 _IOWR('b', 9, struct binder_version)
>
>  /*
> --
> 1.7.9.5
>



--
Arve Hjønnevåg
