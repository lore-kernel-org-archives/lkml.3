Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3DTPUD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 11:20:03 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43097 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab3DTPUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 11:20:00 -0400
Date: Sat, 20 Apr 2013 11:19:45 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: CAI Qian <caiqian@redhat.com>
Cc: Eric Whitney <enwlinux@gmail.com>, Dmitry Monakhov <dmonakhov@openvz.org>,
        Christian Kujau <lists@nerdbynature.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Steve Best <sbest@redhat.com>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
Message-ID: <20130420151945.GA8575@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	CAI Qian <caiqian@redhat.com>, Eric Whitney <enwlinux@gmail.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Christian Kujau <lists@nerdbynature.de>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
References: <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org>
 <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org>
 <87li90q9mx.fsf@openvz.org>
 <87hajoq6s2.fsf@openvz.org>
 <20130403102204.GA15383@gmail.com>
 <20130403122058.GB7741@thunk.org>
 <20130403143406.GA3006@wallace>
 <20130403144114.GB13668@thunk.org>
 <683906006.1314495.1365476711254.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <683906006.1314495.1365476711254.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 11:05:11PM -0400, CAI Qian wrote:
> I can help run xfstests for ext4 dev tree on x64, Power7, Z10 and
> KVM platforms with back-storage like SAN/multipath, iSCSI and FCoE.
> I plan to run this weekly and setup a wiki page to update the testing
> status by every Friday.

Hi CAI,

Sorry for not getting back to you sooner; I was at Collaboration
Summit and LSF/MM last week.

It would be great if you could help run xfstests on the ext4 dev tree
on various platforms.  We don't have any coverage on Power7 or
s390/Z10 at the moment, so that would be especially welcome.  Coverage
on alternate storage backends can be interesting in finding timing
problems so they would be valuable as well.

If you have any Itanium platforms, that would be great too, since we
don't have that today.

The various ext4 configurations which I test can be found in the
kvm-autorun/conf directory in my xfstests-bld git repository:

	git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

(This repository is a convenient setup to do build xfstests in a
hermetic environment, and convenience scripts to run xfstests under
kvm, and scripts on the host OS kick off the kvm test run and parse
the test output afterwards.)

Thanks for offering to test the dev branch!

					- Ted
