Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3LNJ6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 04:58:48 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:40974 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab3LNJ6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 04:58:46 -0500
MIME-Version: 1.0
In-Reply-To: <20131214081944.GR31386@dastard>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
	<1386944873-16796-6-git-send-email-zwu.kernel@gmail.com>
	<20131213164154.GH20803@infradead.org>
	<CAEH94LimS8mUCFwmnVi876mG9GB7DWsqG9p1O=R41XJ3-u1NQg@mail.gmail.com>
	<20131214081944.GR31386@dastard>
Date: Sat, 14 Dec 2013 17:58:45 +0800
Message-ID: <CAEH94Lj_J0X-jP1JoyUCSJPNiPGCPbDnRmJO2GhJX1T+3da-Ug@mail.gmail.com>
Subject: Re: [PATCH 5/5] xfs: allow linkat() on O_TMPFILE files
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        xfstests <xfs@oss.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 4:19 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Dec 14, 2013 at 01:36:47AM +0800, Zhi Yong Wu wrote:
>> On Sat, Dec 14, 2013 at 12:41 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> > On Fri, Dec 13, 2013 at 10:27:53PM +0800, Zhi Yong Wu wrote:
>> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> >>
>> >> Enable O_TMPFILE support in linkat().
>> >> For more info, please refer to:
>> >>   http://oss.sgi.com/archives/xfs/2013-08/msg00341.html
>> >
>> > Generall you should provide all reasonable information in the changelog
>> > instead of linking to it.
>> will apply this, thanks.
>> >
>> >> +     if (sip->i_d.di_nlink == 0)
>> >> +             tres = &M_RES(mp)->tr_link_tmpfile;
>> >> +     else
>> >> +             tres = &M_RES(mp)->tr_link;
>> >
>> > As mentioned before I think Dave wanted you to always use the same
>> > reservation, but I'll leave that discussion to him.
>> If as you said, when some tons of regular files are created, it won't
>> waste some disk space? e.g. some files want to reserve some space, but
>> get NOSPACE due to other files reserving additional space?
>
> This is a log space reservation, not a disk space reservation. End
> either way, what is unused by the transaction is returned to the
> free space pool at the end of the transaction. So for simplicity,
> we should just use the one reservation for the link transaction -
> take whichever is larger at calculation time.
Good explaination, thanks Dave and Christoph. By the way, can you help
check if the log reservation for adding/removing one inode to/from
unlinked list is correct? or  will you check after i post next version
out?

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu
