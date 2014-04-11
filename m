Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaDKVDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:03:40 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:19346 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbaDKVDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:03:38 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0OACJYSFNbsn1W/2dsb2JhbABZgwaCSYEFE8BMAgKBHRd0giUBAQEDATocIwULCAMOCi45HgYTh3QMActmF45sB4Q4AQOYXwGSQoMzOw
Date: Fri, 11 Apr 2014 23:05:30 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Christoph Hellwig <hch@infradead.org>
Cc: Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, jack <jack@suse.cz>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] FS: Add generic data flush to fsync
Message-Id: <20140411230530.984a9d57b3dec487af936d29@skynet.be>
In-Reply-To: <20140411074522.GA15518@infradead.org>
References: <20140411065242.42916952dd5d8e4e53848b3b@skynet.be>
	<20140411074522.GA15518@infradead.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014 00:45:22 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Apr 11, 2014 at 06:52:42AM +0200, Fabian Frederick wrote:
> > Currently, there's no generic HW flush management support in kernel.
> > Only 7 filesystems have their own way to manage the barrier flag.
> > 
> > This patch adds MS_BARRIER in sb_flags and conditionnaly issues the flush
> > in generic_file_fsync.
> 
> Please don't add a binary mount option for something thast already is a
> text option in many filesystems.  We can actually enable/disable cache
> flushes at the block device level, so I think this can be
> unconditional.

Ok, that would mean 'older' filesystems -without barrier flag-
to call generic_file_fsync would result in a flush but ext4 without journal 
also calls it ; maybe with nobarrier and I'm not sure it's the only case.
How can I deal with this problem ?
