Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbbAKOZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 09:25:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbbAKOZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 09:25:32 -0500
Message-ID: <54B287BE.3010107@redhat.com>
Date: Sun, 11 Jan 2015 09:25:02 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
CC: "Elifaz, Dana" <Dana.Elifaz@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Chris Clayton <chris2553@googlemail.com>,
        Oded Gabbay <oded.gabbay@amd.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: fix corner case in anon_vma endless growing prevention
References: <20150111135406.13266.42007.stgit@zurg>
In-Reply-To: <20150111135406.13266.42007.stgit@zurg>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/11/2015 08:54 AM, Konstantin Khlebnikov wrote:
> Fix for BUG_ON(anon_vma->degree) splashes in unlink_anon_vmas() 
> ("kernel BUG at mm/rmap.c:399!").
> 
> Anon_vma_clone() is usually called for a copy of source vma in
> destination argument. If source vma has anon_vma it should be
> already in dst->anon_vma. NULL in dst->anon_vma is used as a sign
> that it's called from anon_vma_fork(). In this case
> anon_vma_clone() finds anon_vma for reusing.
> 
> Vma_adjust() calls it differently and this breaks anon_vma reusing
> logic: anon_vma_clone() links vma to old anon_vma and updates
> degree counters but vma_adjust() overrides vma->anon_vma right
> after that. As a result final unlink_anon_vmas() decrements degree
> for wrong anon_vma.
> 
> This patch assigns ->anon_vma before calling anon_vma_clone().
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com> Fixes:
> 7a3ef208e662 ("mm: prevent endless growth of anon_vma hierarchy") 
> Tested-by: Chris Clayton <chris2553@googlemail.com> Tested-by: Oded
> Gabbay <oded.gabbay@amd.com> Cc: Daniel Forrest
> <dan.forrest@ssec.wisc.edu> Cc: Michal Hocko <mhocko@suse.cz> Cc:
> Rik van Riel <riel@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUsoe+AAoJEM553pKExN6D4x0H/RpBJella2+JhOBPyCBtLY7Z
9w8n14TlqEq7cK/WRmjhYZfVMNGIG3MDe+nAH0hTF0teh/MvJuAkraYnPxtIZYqX
R7IpNOUS3HJBLqsRjNdVNsoMnWOGBC6j/RV70pLj1VklZnq/VDsUPybm0XWk1oh6
nC1QhdLfcnuaFS4M1lzsSyURwQYxi+2vv/kFdtYscArTYmjI7I4gCP3fD7lQKCwK
za0z/oZb5Z5cOHXyQfe/HUROCCNUZUQfcX1XvW+TWvuwcatOvKeVCmJAy5/aPkfH
THtwAP6EyZpu5XwsYXCNfbyalqYpH5lKxd5C+vG86YKEYZyeqRLKLeYAVY3yTho=
=v95A
-----END PGP SIGNATURE-----
