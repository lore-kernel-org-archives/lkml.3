Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaA1M01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:26:27 -0500
Received: from science.horizon.com ([71.41.210.146]:47715 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754436AbaA1M00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:26:26 -0500
Date: 28 Jan 2014 07:26:23 -0500
Message-ID: <20140128122623.26029.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: tmac@hp.com
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
Cc: adilger@dilger.ca, andi@firstfloor.org, linux@horizon.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The third part of the patch further increases the scalablity of an ext4
> filesystem by having each ext4 fielsystem allocate and use its own private
> mbcache structure, instead of sharing a single mcache structures across all
> ext4 filesystems, and increases the size of its mbcache hash tables.

Are you sure this helps?  The idea behind having one large mbcache is
that one large hash table will always be at least as well balanced as
multiple separate tables, if the total size is the same.

If you have two size 2^n hash tables, the chance of collision is equal to
one size  2^(n+1) table if they're equally busy, and if they're unequally
busy. the latter is better.  The busier file system will take less time
per search, and since it's searcehed more often than the less-busy one,
net win.

How does it compare with just increasing the hash table size but leaving
them combined?
