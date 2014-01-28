Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaA2CQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 21:16:04 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:6475 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaA2CP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 21:15:56 -0500
Message-ID: <52E80DF8.7050602@hp.com>
Date: Tue, 28 Jan 2014 13:07:20 -0700
From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andreas Dilger <adilger@dilger.ca>, George Spelvin <linux@horizon.com>
CC: T Makphaibulchoke <tmac@hp.com>, Andi Kleen <andi@firstfloor.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
References: <20140128122623.26029.qmail@science.horizon.com> <848E47EB-5FDF-4DB9-9800-4B1F4B1FA71C@dilger.ca>
In-Reply-To: <848E47EB-5FDF-4DB9-9800-4B1F4B1FA71C@dilger.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 02:09 PM, Andreas Dilger wrote:
> On Jan 28, 2014, at 5:26 AM, George Spelvin <linux@horizon.com> wrote:
>>> The third part of the patch further increases the scalablity of an ext4
>>> filesystem by having each ext4 fielsystem allocate and use its own private
>>> mbcache structure, instead of sharing a single mcache structures across all
>>> ext4 filesystems, and increases the size of its mbcache hash tables.
>>
>> Are you sure this helps?  The idea behind having one large mbcache is
>> that one large hash table will always be at least as well balanced as
>> multiple separate tables, if the total size is the same.
>>
>> If you have two size 2^n hash tables, the chance of collision is equal to
>> one size  2^(n+1) table if they're equally busy, and if they're unequally
>> busy. the latter is better.  The busier file system will take less time
>> per search, and since it's searched more often than the less-busy one,
>> net win.
>>
>> How does it compare with just increasing the hash table size but leaving
>> them combined?
> 
> Except that having one mbcache per block device would avoid the need
> to store the e_bdev pointer in thousands/millions of entries.  Since
> the blocks are never shared between different block devices, there
> is no caching benefit even if the same block is on two block devices.
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

Thanks George and Andreas for the comments.  Andreas you mentions a good point, e_bdev pointer is not needed when having one mb_cache for each block device.  I'll integrate that into my patch, removing the e_bdev pointer, and run some comparison between one large hash table vs multiple hash tables, as suggested by George.

Thanks,
Mak.

