Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab3C1O4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:56:47 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:52098 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3C1O4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:56:44 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: "Theodore Ts'o" <tytso@mit.edu>, CAI Qian <caiqian@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Steve Best <sbest@redhat.com>,
        linux-ext4@vger.kernel.org
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
In-Reply-To: <20130328120517.GB5737@thunk.org>
References: <863434221.7624846.1364452822093.JavaMail.root@redhat.com> <356372233.7624880.1364452833412.JavaMail.root@redhat.com> <20130328120517.GB5737@thunk.org>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Thu, 28 Mar 2013 18:56:37 +0400
Message-ID: <87ppyjd13u.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Mar 2013 08:05:17 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Mar 28, 2013 at 02:40:33AM -0400, CAI Qian wrote:
> > System hung when running xfstests-dev 013 test case on an s390x guest. Never saw
> > this on 3.9-rc3 before but need to double-check. Any idea?
> > 
> > Ý 1113.795759¨ ------------Ý cut here ¨------------
> > Ý 1113.795771¨ kernel BUG at fs/ext4/inode.c:1591!
> 
> thanks for the report.  What kernel version did this come from?  Was
> it 3.9-rc4?  (line 1591 for 3.9-rc3 doesn't contain a BUG_ON).
> 
> If it is indeed 3.9-rc4, it would be helpful, since you can reproduce
> the problem, to insert a debugging printk which fires when
> bh->b_blocknr != pblock before the BUG_ON, and have it print the
> b_blocknr and pblock values.
I've triggered this bug on before at the time i've worked on
e4defrag functionality, but AFAIK all related issues was aready fixed
and 013 has nothing with e4defrag.
But still bh->b_blocknr under us. So other obvious place I suspect is
puch_hole but this also not true because 013 use fsstress
test in vegetarian mode: "-f rmdir=10 -f link=10 -f creat=10 -f mkdir=10
-f rename=30 -f stat=30 -f unlink=30 -f truncate=20"
So the only place I suspect is some unknown bug in extent status tree
Can you please enable ES_AGGRESSIVE_TEST and rerun xfstest.
> 
> Thanks,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
