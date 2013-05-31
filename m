Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab3EaXRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 19:17:43 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63552 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab3EaXRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 19:17:35 -0400
MIME-Version: 1.0
In-Reply-To: <1369217581-16285-4-git-send-email-serban.constantinescu@arm.com>
References: <1369217581-16285-1-git-send-email-serban.constantinescu@arm.com>
	<1369217581-16285-4-git-send-email-serban.constantinescu@arm.com>
Date: Fri, 31 May 2013 16:17:34 -0700
Message-ID: <CAMP5XgeBsr63tcHxoMb2D5dJPuetyLnxNVi8_2V0FM69+AwFbQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] staging: android: binder: fix BINDER_SET_MAX_THREADS
 declaration
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

On Wed, May 22, 2013 at 3:12 AM, Serban Constantinescu
<serban.constantinescu@arm.com> wrote:
> This change will fix the BINDER_SET_MAX_THREADS ioctl to use __u32
> instead of size_t for setting the max threads. Thus using the same
> handler for 32 and 64bit kernels.
>
> This value is stored internally in struct binder_proc and set to 15
> on open_binder() in the libbinder API(thus no need for a 64bit size_t
> on 64bit platforms).
>
> The change does not affect existing 32bit ABI.
>
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> ---
>  drivers/staging/android/binder.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
> index 2f94d16..1761541 100644
> --- a/drivers/staging/android/binder.h
> +++ b/drivers/staging/android/binder.h
> @@ -86,7 +86,7 @@ struct binder_version {
>
>  #define BINDER_WRITE_READ              _IOWR('b', 1, struct binder_write_read)
>  #define        BINDER_SET_IDLE_TIMEOUT         _IOW('b', 3, __s64)
> -#define        BINDER_SET_MAX_THREADS          _IOW('b', 5, size_t)
> +#define        BINDER_SET_MAX_THREADS          _IOW('b', 5, __u32)
>  #define        BINDER_SET_IDLE_PRIORITY        _IOW('b', 6, __s32)
>  #define        BINDER_SET_CONTEXT_MGR          _IOW('b', 7, __s32)
>  #define        BINDER_THREAD_EXIT              _IOW('b', 8, __s32)
> --
> 1.7.9.5
>

Acked-by: Arve Hjønnevåg <arve@android.com>

--
Arve Hjønnevåg
