Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3LMRgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:36:50 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:35620 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab3LMRgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:36:48 -0500
MIME-Version: 1.0
In-Reply-To: <20131213164154.GH20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
	<1386944873-16796-6-git-send-email-zwu.kernel@gmail.com>
	<20131213164154.GH20803@infradead.org>
Date: Sat, 14 Dec 2013 01:36:47 +0800
Message-ID: <CAEH94LimS8mUCFwmnVi876mG9GB7DWsqG9p1O=R41XJ3-u1NQg@mail.gmail.com>
Subject: Re: [PATCH 5/5] xfs: allow linkat() on O_TMPFILE files
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfstests <xfs@oss.sgi.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 12:41 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Dec 13, 2013 at 10:27:53PM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> Enable O_TMPFILE support in linkat().
>> For more info, please refer to:
>>   http://oss.sgi.com/archives/xfs/2013-08/msg00341.html
>
> Generall you should provide all reasonable information in the changelog
> instead of linking to it.
will apply this, thanks.
>
>> +     if (sip->i_d.di_nlink == 0)
>> +             tres = &M_RES(mp)->tr_link_tmpfile;
>> +     else
>> +             tres = &M_RES(mp)->tr_link;
>
> As mentioned before I think Dave wanted you to always use the same
> reservation, but I'll leave that discussion to him.
If as you said, when some tons of regular files are created, it won't
waste some disk space? e.g. some files want to reserve some space, but
get NOSPACE due to other files reserving additional space?

>
>> +/* For creating a link to an O_TMPFILE inode, except modifying
>> + * those metadata for regular inode, we still need to remove an inode
>> + * from unlinked list at first. That is,  we can modify:
>> + *    the agi hash list and counters: sector size
>> + *    the on disk inode before ours in the agi hash list: inode cluster size
>> + */
>
> We always have an emptry content
Done, thanks.
>
> /*
>
> line at the beginning of comments in XFS and the Linux kernel in
> general.
>



-- 
Regards,

Zhi Yong Wu
