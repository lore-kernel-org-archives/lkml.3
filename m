Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbaKAS3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 14:29:54 -0400
Received: from imap.thunk.org ([74.207.234.97]:56409 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbaKAS3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 14:29:52 -0400
Date: Sat, 1 Nov 2014 14:29:50 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 bug fixes for 3.18
Message-ID: <20141101182950.GC31245@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <20141031214949.GA644@thunk.org>
 <CA+55aFwiFx6ejtnEvZYJewHaskwjTr39bPstFvWYimqi6hMCsQ@mail.gmail.com>
 <20141101133802.GA31245@thunk.org>
 <CA+55aFz=Dv=FuVD=WDMjOAi-eG2ZbHT5F7Gc78BpMrVDZKpQnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz=Dv=FuVD=WDMjOAi-eG2ZbHT5F7Gc78BpMrVDZKpQnQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And your point about >16TB filesystems is completely buggy. That was
> *my* point. Most people - even on 64-bit - do *not* have 16TB
> filesystems, and the high 32 bits are zero or contain very very little
> information (ie even on a multi-terabyte filesystem, it's one or two
> bits worth of information). So hash_32() is not only much more
> reasonable on a 32-bit machine, the end result is basically as good
> for 99.999% of all uses. Exactly *because* people don't have those big
> filesystems.

I agree; that's why I suggested using hash_32() if the number of
blocks in the file system is less than 2**32.  I did look at hash_u64
and didn't think it was that bad, but that's probably because compared
to crypto checksums it's positively fast, and it's really easy to get
into the bad habit of thinking that all the world's an x86_64.  :-)

     	     	      	       	    	- Ted
