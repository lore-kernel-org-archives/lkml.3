Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3C1MFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:05:24 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:56702 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab3C1MFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:05:20 -0400
Date: Thu, 28 Mar 2013 08:05:17 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: CAI Qian <caiqian@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Steve Best <sbest@redhat.com>,
        linux-ext4@vger.kernel.org
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
Message-ID: <20130328120517.GB5737@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
References: <863434221.7624846.1364452822093.JavaMail.root@redhat.com>
 <356372233.7624880.1364452833412.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <356372233.7624880.1364452833412.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 02:40:33AM -0400, CAI Qian wrote:
> System hung when running xfstests-dev 013 test case on an s390x guest. Never saw
> this on 3.9-rc3 before but need to double-check. Any idea?
> 
> Ý 1113.795759¨ ------------Ý cut here ¨------------
> Ý 1113.795771¨ kernel BUG at fs/ext4/inode.c:1591!

thanks for the report.  What kernel version did this come from?  Was
it 3.9-rc4?  (line 1591 for 3.9-rc3 doesn't contain a BUG_ON).

If it is indeed 3.9-rc4, it would be helpful, since you can reproduce
the problem, to insert a debugging printk which fires when
bh->b_blocknr != pblock before the BUG_ON, and have it print the
b_blocknr and pblock values.

Thanks,

						- Ted
