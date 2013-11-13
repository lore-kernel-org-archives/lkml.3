Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab3KMOn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:43:59 -0500
Received: from fieldses.org ([174.143.236.118]:51950 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299Ab3KMOnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:43:55 -0500
Date: Wed, 13 Nov 2013 09:43:53 -0500
From: Bruce Fields <bfields@fieldses.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, stable@kernel.org
Subject: Re: [git pull] fixes for 3.12-final
Message-ID: <20131113144353.GE28033@fieldses.org>
References: <20131103015803.GK13318@ZenIV.linux.org.uk>
 <CA+55aFy3tAeLYL3_+PbeD15p6PGS-P7bs8fMUaRVSC0OCzvq6w@mail.gmail.com>
 <20131103195452.GL13318@ZenIV.linux.org.uk>
 <CA+55aFwW9s3GCa+zNTMg7m44-cj2RdJp7wRpCnPUvQHm9xYnFg@mail.gmail.com>
 <20131104005300.GM13318@ZenIV.linux.org.uk>
 <20131106151003.GA21425@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106151003.GA21425@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 03:10:04PM +0000, Al Viro wrote:
> FWIW, not taking ->i_lock there definitely looks like a good thing.  As for
> 64bit ->i_ino itself...  Looks like the main problem is the shitload of
> printks - the actual uses of ->i_ino are fine, but these suckers create
> a lot of noise.  So for now I'm going with Bruce's variant; 64bit i_ino
> doesn't look too bad (even on i386, actually), but it'll have to wait
> until 3.14.  Too noisy and late in this cycle...

I believe we also want that in stable?

950ee9566a5b6cc45d15f5fe044bab4f1e8b62cb "exportfs: fix 32-bit nfsd
handling of 64-bit inode numbers"

--b.
