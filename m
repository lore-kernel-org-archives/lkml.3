Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbaDVTQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:16:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaDVTPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:15:16 -0400
Date: Tue, 22 Apr 2014 09:37:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Christopher Brannon <chris@the-brannons.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: [PATCH 6/9] drivers/staging/speakup/: avoid world-writable sysfs
 files.
Message-ID: <20140422163736.GA23831@kroah.com>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
 <1398137612-9714-7-git-send-email-rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398137612-9714-7-git-send-email-rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:03:29PM +0930, Rusty Russell wrote:
> In line with practice for module parameters, we're adding a build-time
> check that sysfs files aren't world-writable.

Then why not just use the __ATTR_RO() macro?

> 
> Cc: Christopher Brannon <chris@the-brannons.com>
> Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/staging/speakup/kobjects.c       | 60 ++++++++++++++++----------------
>  drivers/staging/speakup/speakup_acntpc.c | 14 ++++----
>  drivers/staging/speakup/speakup_acntsa.c | 14 ++++----
>  drivers/staging/speakup/speakup_apollo.c | 16 ++++-----
>  drivers/staging/speakup/speakup_audptr.c | 16 ++++-----
>  drivers/staging/speakup/speakup_bns.c    | 14 ++++----
>  drivers/staging/speakup/speakup_decext.c | 16 ++++-----
>  drivers/staging/speakup/speakup_decpc.c  | 16 ++++-----
>  drivers/staging/speakup/speakup_dectlk.c | 16 ++++-----
>  drivers/staging/speakup/speakup_dtlk.c   | 20 +++++------
>  drivers/staging/speakup/speakup_dummy.c  | 14 ++++----
>  drivers/staging/speakup/speakup_keypc.c  | 10 +++---
>  drivers/staging/speakup/speakup_ltlk.c   | 20 +++++------
>  drivers/staging/speakup/speakup_soft.c   | 22 ++++++------
>  drivers/staging/speakup/speakup_spkout.c | 16 ++++-----
>  drivers/staging/speakup/speakup_txprt.c  | 14 ++++----
>  16 files changed, 149 insertions(+), 149 deletions(-)
> 
> diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
> index 1ca91f7092b1..c4aa13fc2d13 100644
> --- a/drivers/staging/speakup/kobjects.c
> +++ b/drivers/staging/speakup/kobjects.c
> @@ -853,73 +853,73 @@ static ssize_t message_store(struct kobject *kobj, struct kobj_attribute *attr,
>  static struct kobj_attribute keymap_attribute =
>  	__ATTR(keymap, S_IWUSR|S_IRUGO, keymap_show, keymap_store);
>  static struct kobj_attribute silent_attribute =
> -	__ATTR(silent, S_IWUGO, NULL, silent_store);
> +	__ATTR(silent, S_IWUSR|S_IWGRP, NULL, silent_store);

__ATTR_WO()?

I'd prefer some "standard" permissions for all of these sysfs files,
it's quite confusing otherwise, don't you agree?

thanks

greg k-h
