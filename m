Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab3C2Ixv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 04:53:51 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:45379 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3C2Ixr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 04:53:47 -0400
Date: Fri, 29 Mar 2013 04:53:43 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Steve Best <sbest@redhat.com>,
        linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <20431405.8258404.1364547223843.JavaMail.root@redhat.com>
In-Reply-To: <87ppyjd13u.fsf@openvz.org>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.66.13.149]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Dmitry Monakhov" <dmonakhov@openvz.org>
> To: "Theodore Ts'o" <tytso@mit.edu>, "CAI Qian" <caiqian@redhat.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, "linux-s390" <linux-s390@vger.kernel.org>, "Steve Best"
> <sbest@redhat.com>, linux-ext4@vger.kernel.org
> Sent: Thursday, March 28, 2013 10:56:37 PM
> Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
> 
> On Thu, 28 Mar 2013 08:05:17 -0400, Theodore Ts'o <tytso@mit.edu>
> wrote:
> > On Thu, Mar 28, 2013 at 02:40:33AM -0400, CAI Qian wrote:
> > > System hung when running xfstests-dev 013 test case on an s390x
> > > guest. Never saw
> > > this on 3.9-rc3 before but need to double-check. Any idea?
> > > 
> > > Ý 1113.795759¨ ------------Ý cut here ¨------------
> > > Ý 1113.795771¨ kernel BUG at fs/ext4/inode.c:1591!
> > 
> > thanks for the report.  What kernel version did this come from?
> >  Was
> > it 3.9-rc4?  (line 1591 for 3.9-rc3 doesn't contain a BUG_ON).
> > 
> > If it is indeed 3.9-rc4, it would be helpful, since you can
> > reproduce
> > the problem, to insert a debugging printk which fires when
> > bh->b_blocknr != pblock before the BUG_ON, and have it print the
> > b_blocknr and pblock values.
> I've triggered this bug on before at the time i've worked on
> e4defrag functionality, but AFAIK all related issues was aready fixed
> and 013 has nothing with e4defrag.
> But still bh->b_blocknr under us. So other obvious place I suspect is
> puch_hole but this also not true because 013 use fsstress
> test in vegetarian mode: "-f rmdir=10 -f link=10 -f creat=10 -f
> mkdir=10
> -f rename=30 -f stat=30 -f unlink=30 -f truncate=20"
> So the only place I suspect is some unknown bug in extent status tree
> Can you please enable ES_AGGRESSIVE_TEST and rerun xfstest.
What is ES_AGGRESSIVE_TEST and how can it enable it?
> > 
> > Thanks,
> > 
> > 						- Ted
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
