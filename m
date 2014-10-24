Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbaJXPsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:48:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaJXPsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:48:12 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/4] vfs: Define new syscalls preadv2,pwritev2
References: <cover.1413923420.git.milosz@adfin.com>
	<cover.1413923420.git.milosz@adfin.com>
	<1613303dfaa91e6ff09cdd7860e0316765663ba6.1413923420.git.milosz@adfin.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 24 Oct 2014 11:46:56 -0400
In-Reply-To: <1613303dfaa91e6ff09cdd7860e0316765663ba6.1413923420.git.milosz@adfin.com>
	(Milosz Tanski's message of "Tue, 21 Oct 2014 16:46:57 -0400")
Message-ID: <x49oat1o4gf.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> writes:

> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index 22749c1..10f8883 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -213,6 +213,10 @@ __SC_COMP(__NR_pwrite64, sys_pwrite64, compat_sys_pwrite64)
>  __SC_COMP(__NR_preadv, sys_preadv, compat_sys_preadv)
>  #define __NR_pwritev 70
>  __SC_COMP(__NR_pwritev, sys_pwritev, compat_sys_pwritev)
> +#define __NR_preadv2 281
> +__SC_COMP(__NR_preadv2, sys_preadv2)
> +#define __NR_pwritev2 282
> +__SC_COMP(__NR_pwritev2, sys_pwritev2)

This looks odd.  First, __SC_COMP takes 3 arguments.  Second, you are
going to need to implement compat wrappers for the new system calls.

Cheers,
Jeff
