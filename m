Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab3JOSnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:43:05 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:60523 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab3JOSnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:43:01 -0400
MIME-Version: 1.0
In-Reply-To: <20131015110905.085B1E0090@blue.fi.intel.com>
References: <20131015001826.GL3432@hippobay.mtv.corp.google.com> <20131015110905.085B1E0090@blue.fi.intel.com>
From: Ning Qu <quning@google.com>
Date: Tue, 15 Oct 2013 11:42:39 -0700
Message-ID: <CACz4_2cVZBxg88hqzOHpASN4e=hVYMTTQkXHssDjfXpcqACONw@mail.gmail.com>
Subject: Re: [PATCH 11/12] mm, thp, tmpfs: enable thp page cache in tmpfs
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with this. It has been like this just for a quick proof, but I
need to address this problem as soon as possible.

Thanks!
Best wishes,
-- 
Ning Qu (曲宁) | Software Engineer | quning@google.com | +1-408-418-6066


On Tue, Oct 15, 2013 at 4:09 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Ning Qu wrote:
>> Signed-off-by: Ning Qu <quning@gmail.com>
>> ---
>>  mm/Kconfig | 4 ++--
>>  mm/shmem.c | 5 +++++
>>  2 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 562f12f..4d2f90f 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -428,8 +428,8 @@ config TRANSPARENT_HUGEPAGE_PAGECACHE
>>       help
>>         Enabling the option adds support hugepages for file-backed
>>         mappings. It requires transparent hugepage support from
>> -       filesystem side. For now, the only filesystem which supports
>> -       hugepages is ramfs.
>> +       filesystem side. For now, the filesystems which support
>> +       hugepages are: ramfs and tmpfs.
>>
>>  config CROSS_MEMORY_ATTACH
>>       bool "Cross Memory Support"
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 75c0ac6..50a3335 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1672,6 +1672,11 @@ static struct inode *shmem_get_inode(struct super_block *sb, const struct inode
>>                       break;
>>               case S_IFREG:
>>                       inode->i_mapping->a_ops = &shmem_aops;
>> +                     /*
>> +                      * TODO: make tmpfs pages movable
>> +                      */
>> +                     mapping_set_gfp_mask(inode->i_mapping,
>> +                                          GFP_TRANSHUGE & ~__GFP_MOVABLE);
>
> Unlike ramfs, tmpfs pages are movable before transparent page cache
> patchset.
> Making tmpfs pages non-movable looks like a big regression to me. It need
> to be fixed before proposing it upstream.
>
> --
>  Kirill A. Shutemov
