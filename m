Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbaDMUue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 16:50:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44218 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbaDMUud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 16:50:33 -0400
Date: Sun, 13 Apr 2014 21:50:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: Initialize error in shmem_file_aio_read()
Message-ID: <20140413205029.GO18016@ZenIV.linux.org.uk>
References: <1397414783-28098-1-git-send-email-geert@linux-m68k.org>
 <1397414783-28098-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397414783-28098-2-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 08:46:22PM +0200, Geert Uytterhoeven wrote:
> mm/shmem.c: In function ‘shmem_file_aio_read’:
> mm/shmem.c:1414: warning: ‘error’ may be used uninitialized in this function
> 
> If the loop is aborted during the first iteration by one of the two first
> break statements, error will be uninitialized.
> 
> Introduced by commit 6e58e79db8a16222b31fc8da1ca2ac2dccfc4237
> ("introduce copy_page_to_iter, kill loop over iovec in
> generic_file_aio_read()").
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> The code is too complex to see if this is an obvious false positive.

Good catch; sadly, it *can* be triggered - read() starting past the EOF
will step into it.  Applied, will push today.
