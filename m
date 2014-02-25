Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaBYSDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:03:08 -0500
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:9684 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752844AbaBYSDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:03:06 -0500
Message-ID: <530CDA6C.9010008@tuxera.com>
Date: Tue, 25 Feb 2014 20:01:16 +0200
From: sougata <sougata@tuxera.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20111010 Icedove/3.1.15
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joe Perches <joe@perches.com>, Vyacheslav Dubeyko <slava@dubeyko.com>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] hfsplus: fix longname handling
References: <1393270107.27792.9.camel@ultrabook> <20140224134832.d64b1e76e2d6d8fe5b25598d@linux-foundation.org>
In-Reply-To: <20140224134832.d64b1e76e2d6d8fe5b25598d@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.166.4.239]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 11:48 PM, Andrew Morton wrote:
> On Mon, 24 Feb 2014 21:28:27 +0200 Sougata Santra<sougata@tuxera.com>  wrote:
>
>>
>> -ENAMETOOLONG returned from hfsplus_asc2uni was not propaged to iops. This
>> allowed hfsplus to create files/directories with HFSPLUS_MAX_STRLEN and
>> incorrect keys, leaving the FS in an inconsistent state. This patch fixes
>> this issue.
>>
>> ...
>>
>> --- a/fs/hfsplus/hfsplus_fs.h
>> +++ b/fs/hfsplus/hfsplus_fs.h
>> @@ -443,8 +443,10 @@ int hfsplus_cat_case_cmp_key(const hfsplus_btree_key *,
>>   		const hfsplus_btree_key *);
>>   int hfsplus_cat_bin_cmp_key(const hfsplus_btree_key *,
>>   		const hfsplus_btree_key *);
>> -void hfsplus_cat_build_key(struct super_block *sb,
>> +int hfsplus_cat_build_key(struct super_block *sb,
>>   		hfsplus_btree_key *, u32, struct qstr *);
>> +void hfsplus_cat_build_key_with_cnid(struct super_block *sb,
>> +		hfsplus_btree_key *, u32);
>>   int hfsplus_find_cat(struct super_block *, u32, struct hfs_find_data *);
>>   int hfsplus_create_cat(u32, struct inode *, struct qstr *, struct inode *);
>>   int hfsplus_delete_cat(u32, struct inode *, struct qstr *);
>
> grumble.  Omitting the argument names from declarations makes them
> unreadable and generally useless.  I mean, a bare u32?
>
> And including the names of some arguments but omitting others is
> downright bizarre.
>
> However this isn't a thing which can or should be addressed within this
> patch.

Also in hfsplus_fs.h there are:

====> snip <=====
#define hfs_btree_open hfsplus_btree_open
#define hfs_btree_close hfsplus_btree_close
#define hfs_btree_write hfsplus_btree_write
#define hfs_bmap_alloc hfsplus_bmap_alloc
#define hfs_bmap_free hfsplus_bmap_free
#define hfs_bnode_read hfsplus_bnode_read
...
====> snap <=====

Does these exist for some legacy reason or does it serve any other 
purpose ?. The only usage I see is that they change function names after 
pre-processing.

Thanks a lot,

Best regards,
     Sougata.
