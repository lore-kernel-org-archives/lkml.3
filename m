Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab3H0ViZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:38:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54260 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752419Ab3H0ViY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:38:24 -0400
Message-ID: <1377639503.12865.8.camel@joe-AO722>
Subject: Re: [PATCH] cdrom: fixed a brace coding style issue
From: Joe Perches <joe@perches.com>
To: Imededdine Aimene Bounab <aimene.kernel@gmail.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Date: Tue, 27 Aug 2013 14:38:23 -0700
In-Reply-To: <1377637278-12166-1-git-send-email-aimene.kernel@gmail.com>
References: <1377637278-12166-1-git-send-email-aimene.kernel@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 22:01 +0100, Imededdine Aimene Bounab wrote:
> Fixed a coding style issue.

Hi Imededdine.

Just some simple notes.

Your subject line doesn't match the patch and
you are doing more than a single brace change.

There are lots of whitespace changes.

Maybe multiple patches for easier review would be better.

> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
[]
>  /* These are used to simplify getting data in from and back to user land */
>  #define IOCTL_IN(arg, type, in)					\
> -	if (copy_from_user(&(in), (type __user *) (arg), sizeof (in)))	\
> +	if (copy_from_user(&(in), (type __user *) (arg), sizeof(in)))	\
>  		return -EFAULT;
>  
>  #define IOCTL_OUT(arg, type, out) \
> -	if (copy_to_user((type __user *) (arg), &(out), sizeof (out)))	\
> +	if (copy_to_user((type __user *) (arg), &(out), sizeof(out)))	\
>  		return -EFAULT;

These might as well be expanded in-place.

> @@ -340,7 +340,7 @@ do {							\
>  #define CDROM_CAN(type) (cdi->ops->capability & ~cdi->mask & (type))
>  
>  /* used in the audio ioctls */
> -#define CHECKAUDIO if ((ret=check_for_audio_disc(cdi, cdo))) return ret
> +#define CHECKAUDIO if ((ret = check_for_audio_disc(cdi, cdo))) return ret

This CHECKAUDIO #define isn't used anywhere and could
be deleted.

> @@ -363,7 +363,8 @@ static void cdrom_count_tracks(struct cdrom_device_info *, tracktype*);
>  
>  static int cdrom_mrw_exit(struct cdrom_device_info *cdi);
>  
> -static int cdrom_get_disc_info(struct cdrom_device_info *cdi, disc_information *di);
> +static int cdrom_get_disc_info(struct cdrom_device_info *cdi,
> +		disc_information *di);

Please be consistent with with multi-line statement
indentation.

If this is really an 80 column problem (and if it is,
it's a small one), please use alignment to open paren
like:

static int cdrom_get_disc_info(struct cdrom_device_info *cdi,
			       disc_information *di);

(maximal 8 indent tabs, spaces remainder)

etc...

