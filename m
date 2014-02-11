Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbaBKUU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:20:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbaBKUU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:20:56 -0500
Date: Tue, 11 Feb 2014 12:22:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: devel@driverdev.osuosl.org, swetland@google.com, arve@android.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: android: remove unused constant,
 BINDER_SET_IDLE_PRIORITY
Message-ID: <20140211202211.GA2306@kroah.com>
References: <1391828381-4303-1-git-send-email-sj38.park@gmail.com>
 <1391828381-4303-2-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391828381-4303-2-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 11:59:41AM +0900, SeongJae Park wrote:
> Remove constant BINDER_SET_IDLE_PRIORITY because it is not used from
> anywhere.

> 
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
> ---
>  drivers/staging/android/binder.h | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
> index c4c1ed6..6d08e61 100644
> --- a/drivers/staging/android/binder.h
> +++ b/drivers/staging/android/binder.h
> @@ -87,10 +87,9 @@ struct binder_version {
>  #define BINDER_WRITE_READ		_IOWR('b', 1, struct binder_write_read)
>  #define BINDER_SET_IDLE_TIMEOUT		_IOW('b', 3, __s64)
>  #define BINDER_SET_MAX_THREADS		_IOW('b', 5, __u32)
> -#define BINDER_SET_IDLE_PRIORITY	_IOW('b', 6, __s32)
> -#define BINDER_SET_CONTEXT_MGR		_IOW('b', 7, __s32)
> -#define BINDER_THREAD_EXIT		_IOW('b', 8, __s32)
> -#define BINDER_VERSION			_IOWR('b', 9, struct binder_version)
> +#define BINDER_SET_CONTEXT_MGR		_IOW('b', 6, __s32)
> +#define BINDER_THREAD_EXIT		_IOW('b', 7, __s32)
> +#define BINDER_VERSION			_IOWR('b', 8, struct binder_version)

And you just broke all userspace code that uses this interface :(

Please be more careful, and test your patches properly.

greg k-h
