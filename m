Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaAYGJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 01:09:29 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:46542 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaAYGJ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 01:09:26 -0500
References: <1377186876-57291-1-git-send-email-tmac@hp.com> <1390588288-66930-1-git-send-email-tmac@hp.com> <87fvodcb65.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <87fvodcb65.fsf@tassilo.jf.intel.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <DBA818DD-1C87-4B98-8475-8BB8F00F7DA4@dilger.ca>
Cc: T Makphaibulchoke <tmac@hp.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "aswin@hp.com" <aswin@hp.com>
X-Mailer: iPhone Mail (11B554a)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
Date: Fri, 24 Jan 2014 23:09:24 -0700
To: Andi Kleen <andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the ext4 block groups are locked with the blockgroup_lock that has about the same number of locks as the number of cores, with a max of 128, IIRC.  See blockgroup_lock.h. 

While there is some chance of contention, it is also unlikely that all of the cores are locking this area at the same time.  

Cheers, Andreas

> On Jan 24, 2014, at 14:38, Andi Kleen <andi@firstfloor.org> wrote:
> 
> T Makphaibulchoke <tmac@hp.com> writes:
> 
>> The patch consists of three parts.
>> 
>> The first part changes the implementation of both the block and hash chains of
>> an mb_cache from list_head to hlist_bl_head and also introduces new members,
>> including a spinlock to mb_cache_entry, as required by the second part.
> 
> spinlock per entry is usually overkill for larger hash tables.
> 
> Can you use a second smaller lock table that just has locks and is 
> indexed by a subset of the hash key. Most likely a very small 
> table is good enough.
> 
> Also I would be good to have some data on the additional memory consumption.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only
