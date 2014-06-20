Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935045AbaFTQa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:30:59 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:51965 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbaFTQan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:30:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140619052128.GV5015@mwanda>
References: <1403129285-5038-1-git-send-email-xerofoify@gmail.com>
	<20140619052128.GV5015@mwanda>
Date: Fri, 20 Jun 2014 12:30:42 -0400
Message-ID: <CAPDOMVgwT2=iWAHOhgHSBY1B+KoWHQgCdK4idD2miwB=_eMs5Q@mail.gmail.com>
Subject: Re: [PATCH] Check for Null return of function of affs_bread in
 function affs_truncate
From: Nick Krause <xerofoify@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, fabf@skynet.be,
        kirill.shutemov@linux.intel.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok that's fine I would return as if it's a NULL the other parts of the
function can't continue.
Nick

On Thu, Jun 19, 2014 at 1:21 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Wed, Jun 18, 2014 at 06:08:05PM -0400, Nicholas Krause wrote:
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  fs/affs/file.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/affs/file.c b/fs/affs/file.c
>> index a7fe57d..f26482d 100644
>> --- a/fs/affs/file.c
>> +++ b/fs/affs/file.c
>> @@ -923,6 +923,8 @@ affs_truncate(struct inode *inode)
>>
>>       while (ext_key) {
>>               ext_bh = affs_bread(sb, ext_key);
>> +             if (!ext_bh)
>> +                     return;
>
> The problem is that we don't know if we should return here or break
> here.  If you don't understand the code, then it's best to just leave it
> alone.
>
> regards,
> dan carpenter
>
>>               size = AFFS_SB(sb)->s_hashsize;
>>               if (size > blkcnt - blk)
>>                       size = blkcnt - blk;
>> --
>> 1.9.1
