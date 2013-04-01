Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab3DAGaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:30:52 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38862 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab3DAGav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:30:51 -0400
Date: Mon, 1 Apr 2013 02:30:47 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Steve Best <sbest@redhat.com>,
        linux-ext4@vger.kernel.org
Message-ID: <1211053180.322948.1364797847717.JavaMail.root@redhat.com>
In-Reply-To: <87ip46ss0o.fsf@openvz.org>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF19 (Linux)/8.0.3_GA_5664)
Thread-Topic: s390x: kernel BUG at fs/ext4/inode.c:1591!
Thread-Index: 7SsAcucfWG0ZYXad0MbbQJKEzLiHtA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Dmitry Monakhov" <dmonakhov@openvz.org>
> To: "CAI Qian" <caiqian@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, "linux-s390" <linux-s390@vger.kernel.org>, "Steve Best"
> <sbest@redhat.com>, linux-ext4@vger.kernel.org
> Sent: Monday, April 1, 2013 2:07:35 PM
> Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
> 
> On Fri, 29 Mar 2013 05:27:02 -0400 (EDT), CAI Qian <caiqian@redhat.com>
> wrote:
> > 
> I've spent a half of weekend by trying to create s390x guest image,
> without any success. Can you please share it.
Well, do you have something like IBM system-Z?
http://en.wikipedia.org/wiki/IBM_System_z10

Also can be reproduced on system-p,
http://en.wikipedia.org/wiki/IBM_System_p

Never seen it on x86 so far though.
CAI Qian
> > 
> > ----- Original Message -----
> > > From: "Theodore Ts'o" <tytso@mit.edu>
> > > To: "CAI Qian" <caiqian@redhat.com>
> > > Cc: "LKML" <linux-kernel@vger.kernel.org>, "linux-s390"
> > > <linux-s390@vger.kernel.org>, "Steve Best"
> > > <sbest@redhat.com>, linux-ext4@vger.kernel.org
> > > Sent: Thursday, March 28, 2013 8:05:17 PM
> > > Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
> > > 
> > > On Thu, Mar 28, 2013 at 02:40:33AM -0400, CAI Qian wrote:
> > > > System hung when running xfstests-dev 013 test case on an s390x
> > > > guest. Never saw
> > > > this on 3.9-rc3 before but need to double-check. Any idea?
> > > > 
> > > > Ý 1113.795759¨ ------------Ý cut here ¨------------
> > > > Ý 1113.795771¨ kernel BUG at fs/ext4/inode.c:1591!
> > > 
> > > thanks for the report.  What kernel version did this come from?  Was
> > > it 3.9-rc4?  (line 1591 for 3.9-rc3 doesn't contain a BUG_ON).
> > Yes, the lastest mainline.
> > > 
> > > If it is indeed 3.9-rc4, it would be helpful, since you can reproduce
> > > the problem, to insert a debugging printk which fires when
> > > bh->b_blocknr != pblock before the BUG_ON, and have it print the
> > > b_blocknr and pblock values.
> > bh->b_blocknr=100346
> > pblock=66797
> > 
> > Bisecting results so far,
> > git bisect start
> > # good: [a937536b868b8369b98967929045f1df54234323] Linux 3.9-rc3
> > git bisect good a937536b868b8369b98967929045f1df54234323
> > # bad: [9064171268d838b8f283fe111ef086b9479d059a] Merge tag 'for-linus' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/next-fixes
> > git bisect bad 9064171268d838b8f283fe111ef086b9479d059a
> > # bad: [38d78e587d4960d0db94add518d27ee74bad2301] mqueue: sys_mq_open: do
> > not call mnt_drop_write() if read-only
> > git bisect bad 38d78e587d4960d0db94add518d27ee74bad2301
> > # good: [e7489622d3603b7d161b484dcd340d9f678b0c7a] Merge tag 'arm64-fixes'
> > of git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64
> > git bisect good e7489622d3603b7d161b484dcd340d9f678b0c7a
> > # good: [172a271b5e090da7468c66b9ccbcdb3d929eed75] Merge branch 'drm-fixes'
> > of git://people.freedesktop.org/~airlied/linux
> > git bisect good 172a271b5e090da7468c66b9ccbcdb3d929eed75
> > # good: [0a7e453103b9718d357688b83bb968ee108cc874] Merge branch 'next' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux
> > git bisect good 0a7e453103b9718d357688b83bb968ee108cc874
> > # bad: [0e401101db49959f5783f6ee9e676124b5a183ac] ext4: fix memory leakage
> > in mext_check_coverage
> > git bisect bad 0e401101db49959f5783f6ee9e676124b5a183ac
> > CAI Qian
> > > 
> > > Thanks,
> > > 
> > > 						- Ted
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
