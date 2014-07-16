Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbaGPKKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:10:12 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40526 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaGPKKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:10:10 -0400
Date: Wed, 16 Jul 2014 03:08:31 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: David Herrmann <dh.herrmann@gmail.com>
cc: linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Greg Kroah-Hartman <greg@kroah.com>, john.stultz@linaro.org,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Hugh Dickins <hughd@google.com>,
        Tony Battersby <tonyb@cybernetics.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 5/7] selftests: add memfd/sealing page-pinning tests
In-Reply-To: <1402655819-14325-6-git-send-email-dh.herrmann@gmail.com>
Message-ID: <alpine.LSU.2.11.1407160307460.1775@eggly.anvils>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com> <1402655819-14325-6-git-send-email-dh.herrmann@gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, David Herrmann wrote:

> Setting SEAL_WRITE is not possible if there're pending GUP users. This
> commit adds selftests for memfd+sealing that use FUSE to create pending
> page-references. FUSE is very helpful here in that it allows us to delay
> direct-IO operations for an arbitrary amount of time. This way, we can
> force the kernel to pin pages and then run our normal selftests.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

I had a number of problems in getting this working (on openSUSE 13.1):
rpm told me I had fuse installed, yet I had to download and install
the tarball to get header files needed; then "make fuse_mnt" told me
to add -D_FILE_OFFSET_BITS=64 to the compile flags; after which I
got "undefined reference to `fuse_main_real'"; but then I tried
"make run_fuse" as root, and it seemed to sort these issues out
for itself, aside from "./run_fuse_test.sh: Permission denied" -
which was within my bounds of comprehension unlike the rest!

No complaint, thanks for providing the test (though I didn't check
the source to convince myself that "DONE" has done what's claimed):
some rainy day someone can get the Makefile working more smoothly,
no need to delay the patchset for this.

Hugh
