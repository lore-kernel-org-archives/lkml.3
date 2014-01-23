Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaAWVeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:34:50 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25266 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbaAWVes convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:34:48 -0500
From: Chris Mason <clm@fb.com>
To: "jlbec@evilplan.org" <jlbec@evilplan.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Thread-Topic: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Thread-Index: AQHPFx61ZXTlm16UX0ihGnyWT2seDpqRAjIAgABNLACAAAa5AIAABq0AgAAFt4CAAB0+gIAABPgAgAALu4CAAALjgIAABusAgAACUICAAb8ZAIAAAlYA
Date: Thu, 23 Jan 2014 21:34:08 +0000
Message-ID: <1390512936.1198.76.camel@ret.masoncoding.com>
References: <52DFD168.8080001@redhat.com> <20140122143452.GW4963@suse.de>
	 <52DFDCA6.1050204@redhat.com> <20140122151913.GY4963@suse.de>
	 <1390410233.1198.7.camel@ret.masoncoding.com>
	 <1390411300.2372.33.camel@dabdike.int.hansenpartnership.com>
	 <1390413819.1198.20.camel@ret.masoncoding.com>
	 <1390414439.2372.53.camel@dabdike.int.hansenpartnership.com>
	 <1390415924.1198.36.camel@ret.masoncoding.com>
	 <1390416421.2372.68.camel@dabdike.int.hansenpartnership.com>
	 <20140123212714.GB25376@localhost>
In-Reply-To: <20140123212714.GB25376@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="utf-7"
Content-ID: <6D6D2A0E58E35242BCD21F557B2D861D@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-23_05:2014-01-23,2014-01-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=7.28500593183412e-12 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997696947966296
 urlsuspect_oldscore=0.997696947966296 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997696947966296 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401230149
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-23 at 13:27 -0800, Joel Becker wrote:
+AD4- On Wed, Jan 22, 2014 at 10:47:01AM -0800, James Bottomley wrote:
+AD4- +AD4- On Wed, 2014-01-22 at 18:37 +-0000, Chris Mason wrote:
+AD4- +AD4- +AD4- On Wed, 2014-01-22 at 10:13 -0800, James Bottomley wrote:
+AD4- +AD4- +AD4- +AD4- On Wed, 2014-01-22 at 18:02 +-0000, Chris Mason wrote:
+AD4- +AD4- +AFs-agreement cut because it's boring for the reader+AF0-
+AD4- +AD4- +AD4- +AD4- Realistically, if you look at what the I/O schedulers output on a
+AD4- +AD4- +AD4- +AD4- standard (spinning rust) workload, it's mostly large transfers.
+AD4- +AD4- +AD4- +AD4- Obviously these are misalgned at the ends, but we can fix some of that
+AD4- +AD4- +AD4- +AD4- in the scheduler.  Particularly if the FS helps us with layout.  My
+AD4- +AD4- +AD4- +AD4- instinct tells me that we can fix 99+ACU- of this with layout on the FS +- io
+AD4- +AD4- +AD4- +AD4- schedulers ... the remaining 1+ACU- goes to the drive as needing to do RMW
+AD4- +AD4- +AD4- +AD4- in the device, but the net impact to our throughput shouldn't be that
+AD4- +AD4- +AD4- +AD4- great.
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- There are a few workloads where the VM and the FS would team up to make
+AD4- +AD4- +AD4- this fairly miserable
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- Small files.  Delayed allocation fixes a lot of this, but the VM doesn't
+AD4- +AD4- +AD4- realize that fileA, fileB, fileC, and fileD all need to be written at
+AD4- +AD4- +AD4- the same time to avoid RMW.  Btrfs and MD have setup plugging callbacks
+AD4- +AD4- +AD4- to accumulate full stripes as much as possible, but it still hurts.
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- Metadata.  These writes are very latency sensitive and we'll gain a lot
+AD4- +AD4- +AD4- if the FS is explicitly trying to build full sector IOs.
+AD4- +AD4- 
+AD4- +AD4- OK, so these two cases I buy ... the question is can we do something
+AD4- +AD4- about them today without increasing the block size?
+AD4- +AD4- 
+AD4- +AD4- The metadata problem, in particular, might be block independent: we
+AD4- +AD4- still have a lot of small chunks to write out at fractured locations.
+AD4- +AD4- With a large block size, the FS knows it's been bad and can expect the
+AD4- +AD4- rolled up newspaper, but it's not clear what it could do about it.
+AD4- +AD4- 
+AD4- +AD4- The small files issue looks like something we should be tackling today
+AD4- +AD4- since writing out adjacent files would actually help us get bigger
+AD4- +AD4- transfers.
+AD4- 
+AD4- ocfs2 can actually take significant advantage here, because we store
+AD4- small file data in-inode.  This would grow our in-inode size from +AH4-3K to
+AD4- +AH4-15K or +AH4-63K.  We'd actually have to do more work to start putting more
+AD4- than one inode in a block (thought that would be a promising avenue too
+AD4- once the coordination is solved generically.

Btrfs already defaults to 16K metadata and can go as high as 64k.  The
part we don't do is multi-page sectors for data blocks.

I'd tend to leverage the read/modify/write engine from the raid code for
that.

-chris

