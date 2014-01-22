Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaAVRCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:02:43 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37475 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979AbaAVRCf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:02:35 -0500
From: Chris Mason <clm@fb.com>
To: "mgorman@suse.de" <mgorman@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Thread-Topic: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Thread-Index: AQHPFx61ZXTlm16UX0ihGnyWT2seDpqRAjIAgABNLACAAAa5AIAABq0AgAAFt4CAAB0+gA==
Date: Wed, 22 Jan 2014 17:02:22 +0000
Message-ID: <1390410233.1198.7.camel@ret.masoncoding.com>
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com>
	 <20140122093435.GS4963@suse.de> <52DFD168.8080001@redhat.com>
	 <20140122143452.GW4963@suse.de> <52DFDCA6.1050204@redhat.com>
	 <20140122151913.GY4963@suse.de>
In-Reply-To: <20140122151913.GY4963@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="utf-7"
Content-ID: <4E67A8110517DE4EBE4C6EAB2166FDA1@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-22_06:2014-01-22,2014-01-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.36113342819044e-12 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997696947966296
 urlsuspect_oldscore=0.997696947966296 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997696947966296 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401220113
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 15:19 +-0000, Mel Gorman wrote:
+AD4- On Wed, Jan 22, 2014 at 09:58:46AM -0500, Ric Wheeler wrote:
+AD4- +AD4- On 01/22/2014 09:34 AM, Mel Gorman wrote:
+AD4- +AD4- +AD4-On Wed, Jan 22, 2014 at 09:10:48AM -0500, Ric Wheeler wrote:
+AD4- +AD4- +AD4APg-On 01/22/2014 04:34 AM, Mel Gorman wrote:
+AD4- +AD4- +AD4APgA+-On Tue, Jan 21, 2014 at 10:04:29PM -0500, Ric Wheeler wrote:
+AD4- +AD4- +AD4APgA+AD4-One topic that has been lurking forever at the edges is the current
+AD4- +AD4- +AD4APgA+AD4-4k limitation for file system block sizes. Some devices in
+AD4- +AD4- +AD4APgA+AD4-production today and others coming soon have larger sectors and it
+AD4- +AD4- +AD4APgA+AD4-would be interesting to see if it is time to poke at this topic
+AD4- +AD4- +AD4APgA+AD4-again.
+AD4- +AD4- +AD4APgA+AD4-
+AD4- +AD4- +AD4APgA+-Large block support was proposed years ago by Christoph Lameter
+AD4- +AD4- +AD4APgA+-(http://lwn.net/Articles/232757/). I think I was just getting started
+AD4- +AD4- +AD4APgA+-in the community at the time so I do not recall any of the details. I do
+AD4- +AD4- +AD4APgA+-believe it motivated an alternative by Nick Piggin called fsblock though
+AD4- +AD4- +AD4APgA+-(http://lwn.net/Articles/321390/). At the very least it would be nice to
+AD4- +AD4- +AD4APgA+-know why neither were never merged for those of us that were not around
+AD4- +AD4- +AD4APgA+-at the time and who may not have the chance to dive through mailing list
+AD4- +AD4- +AD4APgA+-archives between now and March.
+AD4- +AD4- +AD4APgA+-
+AD4- +AD4- +AD4APgA+-FWIW, I would expect that a show-stopper for any proposal is requiring
+AD4- +AD4- +AD4APgA+-high-order allocations to succeed for the system to behave correctly.
+AD4- +AD4- +AD4APgA+-
+AD4- +AD4- +AD4APg-I have a somewhat hazy memory of Andrew warning us that touching
+AD4- +AD4- +AD4APg-this code takes us into dark and scary places.
+AD4- +AD4- +AD4APg-
+AD4- +AD4- +AD4-That is a light summary. As Andrew tends to reject patches with poor
+AD4- +AD4- +AD4-documentation in case we forget the details in 6 months, I'm going to guess
+AD4- +AD4- +AD4-that he does not remember the details of a discussion from 7ish years ago.
+AD4- +AD4- +AD4-This is where Andrew swoops in with a dazzling display of his eidetic
+AD4- +AD4- +AD4-memory just to prove me wrong.
+AD4- +AD4- +AD4-
+AD4- +AD4- +AD4-Ric, are there any storage vendor that is pushing for this right now?
+AD4- +AD4- +AD4-Is someone working on this right now or planning to? If they are, have they
+AD4- +AD4- +AD4-looked into the history of fsblock (Nick) and large block support (Christoph)
+AD4- +AD4- +AD4-to see if they are candidates for forward porting or reimplementation?
+AD4- +AD4- +AD4-I ask because without that person there is a risk that the discussion
+AD4- +AD4- +AD4-will go as follows
+AD4- +AD4- +AD4-
+AD4- +AD4- +AD4-Topic leader: Does anyone have an objection to supporting larger block
+AD4- +AD4- +AD4-	sizes than the page size?
+AD4- +AD4- +AD4-Room: Send patches and we'll talk.
+AD4- +AD4- +AD4-
+AD4- +AD4- 
+AD4- +AD4- I will have to see if I can get a storage vendor to make a public
+AD4- +AD4- statement, but there are vendors hoping to see this land in Linux in
+AD4- +AD4- the next few years.
+AD4- 
+AD4- What about the second and third questions -- is someone working on this
+AD4- right now or planning to? Have they looked into the history of fsblock
+AD4- (Nick) and large block support (Christoph) to see if they are candidates
+AD4- for forward porting or reimplementation?

I really think that if we want to make progress on this one, we need
code and someone that owns it.  Nick's work was impressive, but it was
mostly there for getting rid of buffer heads.  If we have a device that
needs it and someone working to enable that device, we'll go forward
much faster.

-chris

