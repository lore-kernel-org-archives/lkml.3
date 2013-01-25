Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab3AYODY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:03:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab3AYODV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:03:21 -0500
Date: Fri, 25 Jan 2013 09:03:18 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v2] userns: improve uid/gid map collision detection
Message-ID: <20130125140317.GS17632@redhat.com>
References: <20130123160221.GG17632@redhat.com>
 <20130124044438.GA13354@mail.hallyn.com>
 <20130124152859.GP17632@redhat.com>
 <20130124164612.af6de6f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124164612.af6de6f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 04:46:12PM -0800, Andrew Morton wrote:
> eek, a macro!  Macros are always bad.
> 
> This one is bad because
> 
> a) it's a macro
> 
> b) it evaluates its args multiple times and hence will cause nasty
>    bugs if called with expressions-with-side-effects.
> 
> c) it evaluates its args multiple times and if called with
>    non-trivial expressions the compiler might not be able to CSE those
>    expressions, leading to code bloat.
> 
> Add lo, this patch:
> 
> --- a/kernel/user_namespace.c~userns-improve-uid-gid-map-collision-detection-fix
> +++ a/kernel/user_namespace.c
> @@ -521,7 +521,11 @@ struct seq_operations proc_projid_seq_op
>  
>  static DEFINE_MUTEX(id_map_mutex);
>  
> -#define in_range(b,first,len) ((b)>=(first)&&(b)<(first)+(len))
> +static bool in_range(u32 b, u32 first, u32 len)
> +{
> +	return b >= first && b < first + len;
> +}
> +
>  static inline int extent_collision(struct uid_gid_map *new_map,
>  				   struct uid_gid_extent *extent)
>  {
> 
> reduces the user_namespace.o text from 4822 bytes to 4727 with
> gcc-4.4.4.  This is a remarkably large difference.

thanks Andrew

(I see Eric already answered about the config option)

-- 
Aristeu

