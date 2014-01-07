Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaAGWJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 17:09:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1617 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754210AbaAGWJB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 17:09:01 -0500
From: Chris Mason <clm@fb.com>
To: "darrick.wong@oracle.com" <darrick.wong@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "rlb@defaultvalue.org" <rlb@defaultvalue.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "aurelien@aurel32.net" <aurelien@aurel32.net>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "jack@suse.cz" <jack@suse.cz>
Subject: Re: [RFC PATCH] fs: xattr-based FS_IOC_[GS]ETFLAGS interface
Thread-Topic: [RFC PATCH] fs: xattr-based FS_IOC_[GS]ETFLAGS interface
Thread-Index: AQHPC1SBIuZZnKnCxkWv+a255Syox5p5vPyAgAAyl4CAABTvAIAALIsAgAAEagCAACI5gIAAAdOA
Date: Tue, 7 Jan 2014 22:08:16 +0000
Message-ID: <1389132525.23310.22.camel@ret.masoncoding.com>
References: <20140107025855.GA9229@birch.djwong.org>
	 <20140107124831.GD16640@quack.suse.cz>
	 <20140107154935.GA17609@infradead.org> <20140107170430.GA2822@thunk.org>
	 <20140107194356.GC9229@birch.djwong.org>
	 <1389124784.23310.15.camel@ret.masoncoding.com>
	 <20140107220213.GD9229@birch.djwong.org>
In-Reply-To: <20140107220213.GD9229@birch.djwong.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.57.29]
Content-Type: text/plain; charset="utf-7"
Content-ID: <8E4D7AF51D529D468AA9F00C78F031FF@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-07_07:2014-01-07,2014-01-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=6.32827124036339e-15 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997600857122248
 urlsuspect_oldscore=0.997600857122248 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997600857122248 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401070144
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 14:02 -0800, Darrick J. Wong wrote:
+AD4- On Tue, Jan 07, 2014 at 07:59:15PM +-0000, Chris Mason wrote:
+AD4- +AD4- On Tue, 2014-01-07 at 11:43 -0800, Darrick J. Wong wrote:
+AD4- +AD4- +AD4- On Tue, Jan 07, 2014 at 12:04:30PM -0500, Theodore Ts'o wrote:
+AD4- +AD4- +AD4- +AD4- On Tue, Jan 07, 2014 at 07:49:35AM -0800, Christoph Hellwig wrote:
+AD4- +AD4- +AD4- +AD4- +AD4- On Tue, Jan 07, 2014 at 01:48:31PM +-0100, Jan Kara wrote:
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4-   I have to say I'm not thrilled by the idea of juggling strings in
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- userspace and in kernel to set a flag for an inode...
+AD4- +AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- +AD4- Nevermind the massive amounts of code that sit in the filesystem.
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- The reason for this patch was to address what Dave Chinner has called
+AD4- +AD4- +AD4- +AD4- +ACI-a shitty interface+ACIAWw-1+AF0-.  Using bitfields that need to be coordinated
+AD4- +AD4- +AD4- +AD4- across file systems, when sometimes a bit assignment is validly a fs
+AD4- +AD4- +AD4- +AD4- specific thing, and then later becomes something that gets shared
+AD4- +AD4- +AD4- +AD4- across file systems.
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- +AFs-1+AF0- http://thread.gmane.org/gmane.linux.file-systems/80164/focus+AD0-80396
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- If we don't go about it this way, there are alternatives: we could
+AD4- +AD4- +AD4- +AD4- create new ioctls (or a new syscall) as we start running out of bits
+AD4- +AD4- +AD4- +AD4- used by FS+AF8-IOC+AF8AWw-GS+AF0-ETFLAGS.  We can create new ioctls for bits which
+AD4- +AD4- +AD4- +AD4- are intended for fs-specific flags, which then later get promoted to
+AD4- +AD4- +AD4- +AD4- the new syscall when some functionality starts to get shared accross
+AD4- +AD4- +AD4- +AD4- other file systems (probably with a different bit assignment).  This
+AD4- +AD4- +AD4- +AD4- is certainly less code, but it does mean more complexity outside of
+AD4- +AD4- +AD4- +AD4- the code when we try to coordinate new functionality across file
+AD4- +AD4- +AD4- +AD4- systems.
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- I had thought of indexed inode flags as an alternative to the xattr/string
+AD4- +AD4- +AD4- parsing thing.  Feature flags make their first appearance as part of a per-FS
+AD4- +AD4- +AD4- flag-space and are migrated to the common flag-space when there is demand.
+AD4- +AD4- +AD4- It would also avoid the need for each fs to create its own flag ioctl.
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- On the other hand, someone suggested I try remaking IOC+AF8AWw-GS+AF0-ETFLAG as an xattr,
+AD4- +AD4- +AD4- so off I went. :)
+AD4- +AD4- +AD4- 
+AD4- +AD4- 
+AD4- +AD4- At least in btrfs xattrs are more expensive than something right in the
+AD4- +AD4- inode.  We can cache it when we load the inode (it'll be right next to
+AD4- +AD4- the inode most of the time) but for performance critical things I do
+AD4- +AD4- like the good old fashioned flags.
+AD4- 
+AD4- Just to clarify -- I wasn't proposing any on-disk changes for any filesystems,
+AD4- merely creating virtual xattrs that wrap the inode flags.

Ah, sorry I missed that part.  I was assuming that as we run out of
flags we'll want to use real xattrs instead.

+AD4- 
+AD4- +AD4- It's also possible to turn xattrs off, so we have to deal with
+AD4- +AD4- filesystems that are mounted with them off and then back on again.  I
+AD4- +AD4- can't think of huge problems from that right now, just something to be
+AD4- +AD4- aware of.
+AD4- 
+AD4- Just to satisfy my curiosity: are xattrs always separate objects in btrfs?

Strictly speaking, yes.  They aren't in the inode struct.  But most of
the time they will be in the same btree block.  For anything performance
critical we can order the keys to push them to the front.

-chris
