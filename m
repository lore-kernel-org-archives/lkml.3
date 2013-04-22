Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3DVDku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 23:40:50 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:51587 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab3DVDkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 23:40:49 -0400
Date: Sun, 21 Apr 2013 23:40:40 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Whitney <enwlinux@gmail.com>, Dmitry Monakhov <dmonakhov@openvz.org>,
        Christian Kujau <lists@nerdbynature.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Message-ID: <305497386.207466.1366602040697.JavaMail.root@redhat.com>
In-Reply-To: <20130420151945.GA8575@thunk.org>
References: <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org> <87hajoq6s2.fsf@openvz.org> <20130403102204.GA15383@gmail.com> <20130403122058.GB7741@thunk.org> <20130403143406.GA3006@wallace> <20130403144114.GB13668@thunk.org> <683906006.1314495.1365476711254.JavaMail.root@redhat.com> <20130420151945.GA8575@thunk.org>
Subject: Re: [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: ext4: fix a big-endian bug when an extent is zeroed out
Thread-Index: G8t/mMrqJTTMQ92iuzbXuHw5zgr4fw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

----- Original Message -----
> From: "Theodore Ts'o" <tytso@mit.edu>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Eric Whitney" <enwlinux@gmail.com>, "Dmitry Monakhov" <dmonakhov@openvz.org>, "Christian Kujau"
> nerdbynature.de>, "LKML" <linux-kernel@vger.kernel.org>, "linux-s390" <linux-s390@vger.kernel.org>, "Steve
> Best" <sbest@redhat.com>, linux-ext4@vger.kernel.org
> Sent: Saturday, April 20, 2013 11:19:45 PM
> Subject: Re: [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
> 
> On Mon, Apr 08, 2013 at 11:05:11PM -0400, CAI Qian wrote:
> > I can help run xfstests for ext4 dev tree on x64, Power7, Z10 and
> > KVM platforms with back-storage like SAN/multipath, iSCSI and FCoE.
> > I plan to run this weekly and setup a wiki page to update the testing
> > status by every Friday.
> 
> Hi CAI,
> 
> Sorry for not getting back to you sooner; I was at Collaboration
> Summit and LSF/MM last week.
> 
> It would be great if you could help run xfstests on the ext4 dev tree
> on various platforms.  We don't have any coverage on Power7 or
> s390/Z10 at the moment, so that would be especially welcome.  Coverage
> on alternate storage backends can be interesting in finding timing
> problems so they would be valuable as well.
> 
> If you have any Itanium platforms, that would be great too, since we
> don't have that today.
Unfortunately, to get those ia64 up and running with the upstream kernel
required some significant efforts. I'd leave that for now until it is
something very important.
> 
> The various ext4 configurations which I test can be found in the
> kvm-autorun/conf directory in my xfstests-bld git repository:
> 
>         git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git
> 
> (This repository is a convenient setup to do build xfstests in a
> hermetic environment, and convenience scripts to run xfstests under
> kvm, and scripts on the host OS kick off the kvm test run and parse
> the test output afterwards.)
> 
> Thanks for offering to test the dev branch!
OK, will check with that. BTW, git.kernel.org is kind of broken for me
very often those days, as almost all my tests got this,
+ git clone http://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git -b dev
Cloning into 'ext4'...
fatal: The remote end hung up unexpectedly
fatal: recursion detected in die handler

Therefore, it is going to take a while to re-try later as the test systems
here always do testing from a clean environment, i.e., re-install OS, and
then re-clone the tree etc. :\
CAI Qian
> 
>                                         - Ted
> 
