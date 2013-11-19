Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3KSD2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:28:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35160 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab3KSD2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:28:22 -0500
Date: Tue, 19 Nov 2013 03:28:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Charley (Hao Chuan) Chu" <charley.chu@broadcom.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] FS: Fixed buffer overflow issue in seq_read()
Message-ID: <20131119032818.GC10323@ZenIV.linux.org.uk>
References: <FB8A4655DFD2B34DB16AE06DDDD6C0E21BDB93D2@SJEXCHMB12.corp.ad.broadcom.com>
 <20131119012042.GA10323@ZenIV.linux.org.uk>
 <alpine.LFD.2.10.1311181912090.7995@i7.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.10.1311181912090.7995@i7.linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 07:13:54PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 19 Nov 2013, Al Viro wrote:
> > 
> > seq_file: always clear m->count when we free m->buf
> 
> Ok, applied.
> 
> What do you think about then just abstracing out that now common sequence 
> of re-allocating a larger buffer, while clearing m->count?

Sure, no problem, but then we really have only 2 places doing that and no
visible cause to grow more of them.  With this common sequence being that
short, I'm not sure that effort to recall the definition of that helper
won't be more than that to understand the open-coded variant.  Matter of
taste, but IMO in this case the helper makes it slightly less readable...

BTW, I've several old commits that didn't go into the first pile (e.g.
taking read_seqbegin_or_lock() and friends from fs/dcache.c into
linux/seqlock.h, where they obviously belong, etc.) and several regression
fixes; are you OK with pull request tomorrow?  I can post it tonight,
but I'd prefer to leave local toruture running overnight...
