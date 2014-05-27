Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaE0UVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:21:21 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:35880 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaE0UVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:21:20 -0400
MIME-Version: 1.0
In-Reply-To: <5382B4E8.7020806@oracle.com>
References: <1400791604-12094-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<5382B4E8.7020806@oracle.com>
Date: Tue, 27 May 2014 22:21:19 +0200
Message-ID: <CAFo99gbv5x7tmLZqjygcvpR-tZ9bUAUEtocaGRCUaNPPPYq6PQ@mail.gmail.com>
Subject: Re: [Ocfs2-devel] [PATCH] fs: ocfs2: move_extents.c: Fix for possible
 null pointer dereference
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Ok good, then everything is under control.
The result has been that I've done a number of these types of patches to :)

Sending a new patch of that kind then.


Best regards
Rickard Strandqvist


2014-05-26 5:28 GMT+02:00 Jeff Liu <jeff.liu@oracle.com>:
> Hi,
>
> On 05/23/2014 04:46 AM, Rickard Strandqvist wrote:
>> There is otherwise a risk of a possible null pointer dereference.
>>
>> Was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  fs/ocfs2/move_extents.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
>> index 599eb4c..6a8e3c8 100644
>> --- a/fs/ocfs2/move_extents.c
>> +++ b/fs/ocfs2/move_extents.c
>> @@ -902,11 +902,13 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
>>       struct inode *inode = context->inode;
>>       struct ocfs2_dinode *di;
>>       struct buffer_head *di_bh = NULL;
>> -     struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +     struct ocfs2_super *osb;
>>
>>       if (!inode)
>>               return -ENOENT;
>>
>> +     osb = OCFS2_SB(inode->i_sb);
>> +
>>       if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
>>               return -EROFS;
>
> Thanks for your patch, it looks reasonable if we consider it in the context
> of above function only. However, the inode should not be NULL in any case
> given that ocfs2_move_extents() is called by ocfs2_ioctl_move_extents() at
> where the inode is already validated.
>
> IMO, maybe we can just get rid of the useless inode pre-checkup, i.e,
>
> if (!inode)
>         return -ENOENT;
>
>
> Thanks,
> -Jeff
