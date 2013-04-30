Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749Ab3D3Olj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:41:39 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:55367 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760050Ab3D3Olh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:41:37 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2013 10:41:37 EDT
Date: Tue, 30 Apr 2013 14:34:41 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp>
Message-ID: <0000013e5b5de8c2-75b84016-0faf-4b7f-b5e5-e40eb67552ab-000000@email.amazonses.com>
References: <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com> <517E8758.9040803@parallels.com> <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com> <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
 <0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com> <201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.30-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Tetsuo Handa wrote:

> Current diff is:

[off by one stuff okay]

> diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> index 113ec08..be1446a 100644
> --- a/include/linux/slab_def.h
> +++ b/include/linux/slab_def.h
> @@ -126,6 +126,9 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
>  		if (!size)
>  			return ZERO_SIZE_PTR;
>
> +		if (size > KMALLOC_MAX_SIZE)
> +			goto not_found;
> +
>  		i = kmalloc_index(size);

Why is this needed? kmalloc_index should BUG() for too large allocs.

