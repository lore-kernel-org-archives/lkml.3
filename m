Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaFBWD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:03:29 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:58142 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFBWD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:03:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140602132216.292fd8363da83b48e90a78ba@linux-foundation.org>
References: <1401630784-20493-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140602132216.292fd8363da83b48e90a78ba@linux-foundation.org>
Date: Tue, 3 Jun 2014 00:03:27 +0200
Message-ID: <CAFo99gZciEQSNOHw0wVQ8ETTjk87+E2=8uO5vwRkTm6HuqDPsw@mail.gmail.com>
Subject: Re: [PATCH] fs: ocfs2: dir.c: Cleaning up uninitialized variables
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Yes, but if() above, there may be a:
goto out;

Or if kcalloc() fails in ocfs2_dx_dir_kmalloc_leaves() the variable
num_dx_leaves will not be set to any value.

But now that I look more carefully at it, I see that in the cases
orig_dx_leaves and new_dx_leaves ar NULL, so nothing will happen in
the out: part of the code.

Sorry about this :-(


Best regards
Rickard Strandqvist


2014-06-02 22:22 GMT+02:00 Andrew Morton <akpm@linux-foundation.org>:
> On Sun,  1 Jun 2014 15:53:04 +0200 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
>
>> There is a risk that the variable will be used without being initialized.
>
> um, no there isn't.
>
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -3738,7 +3738,7 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
>>       int credits, ret, i, num_used, did_quota = 0;
>>       u32 cpos, split_hash, insert_hash = hinfo->major_hash;
>>       u64 orig_leaves_start;
>> -     int num_dx_leaves;
>> +     int num_dx_leaves = 0;
>>       struct buffer_head **orig_dx_leaves = NULL;
>>       struct buffer_head **new_dx_leaves = NULL;
>>       struct ocfs2_alloc_context *data_ac = NULL, *meta_ac = NULL;
>
> If ocfs2_dx_dir_kmalloc_leaves() returns non-zero, num_dx_leaves will
> have been initialized.
>
