Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab3BFI46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:56:58 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:60613 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3BFI44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:56:56 -0500
Date: Wed, 6 Feb 2013 12:56:53 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: akpm@linux-foundation.org, keescook@chromium.org,
        serge.hallyn@canonical.com, ebiederm@xmission.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: arg2 is unsigned long which is never < 0
Message-ID: <20130206085653.GQ1712@moon>
References: <511217F3.6050800@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511217F3.6050800@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 04:44:35PM +0800, Chen Gang wrote:
> 
>   arg2 will never < 0, for its type is 'unsigned long'
> 
>   so delete the waste code.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/sys.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 24d1ef5..568b9ca 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2027,7 +2027,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  			error = get_dumpable(me->mm);
>  			break;
>  		case PR_SET_DUMPABLE:
> -			if (arg2 < 0 || arg2 > 1) {
> +			if (arg2 > 1) {
>  				error = -EINVAL;
>  				break;
>  			}

I guess

	if (arg2 != SUID_DUMPABLE_DISABLED &&
	    arg2 != SUID_DUMPABLE_ENABLED) {
		error = -EINVAL;
		break;
	}

would be better. Still, current patch looks good to me.
