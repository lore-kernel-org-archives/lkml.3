Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaHTUuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:50:23 -0400
Received: from ozlabs.org ([103.22.144.67]:48487 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbaHTUuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:50:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org
Cc: David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH] params: fix potential memory leak in add_sysfs_param()
In-Reply-To: <1408564816-1778-1-git-send-email-arjun024@gmail.com>
References: <1408564816-1778-1-git-send-email-arjun024@gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 21 Aug 2014 06:19:03 +0930
Message-ID: <87mwayj39c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjun Sreedharan <arjun024@gmail.com> writes:
> Do not leak memory when attrs is non NULL and
> krealloc() fails. Without temporary variable,
> reference to it is lost.
>
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>

...

>  	}
> -	/* Despite looking like the typical realloc() bug, this is safe.
> -	 * We *want* the old 'attrs' to be freed either way, and we'll store
> -	 * the new one in the success case. */
> -	attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
> -	if (!attrs) {
> +
> +	new_attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
> +	if (!new_attrs) {

I think that comment you deleted is pretty clear.  Is it wrong?

Cheers,
Rusty.
