Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab3CKLw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:52:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab3CKLwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:52:25 -0400
Date: Mon, 11 Mar 2013 12:52:20 +0100
From: Jan Kara <jack@suse.cz>
To: Phillip Susi <psusi@ubuntu.com>
Cc: Howard Chu <hyc@symas.com>, Chris Friesen <chris.friesen@genband.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: mmap vs fs cache
Message-ID: <20130311115220.GB29799@quack.suse.cz>
References: <5136320E.8030109@symas.com>
 <20130307154312.GG6723@quack.suse.cz>
 <20130308020854.GC23767@cmpxchg.org>
 <5139975F.9070509@symas.com>
 <20130308084246.GA4411@shutemov.name>
 <5139B214.3040303@symas.com>
 <5139FA13.8090305@genband.com>
 <5139FD27.1030208@symas.com>
 <513A8ECB.8000504@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513A8ECB.8000504@ubuntu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-03-13 20:22:19, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 03/08/2013 10:00 AM, Howard Chu wrote:
> > Yes, that's what I was thinking. I added a 
> > posix_madvise(..POSIX_MADV_RANDOM) but that had no effect on the
> > test.
> 
> Yep, that's because it isn't implemented.
  Why do you think so? AFAICS it is implemented by setting VM_RAND_READ
flag in the VMA and do_async_mmap_readahead() and do_sync_mmap_readahead()
check for the flag and don't do anything if it is set...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
