Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaAVPO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:14:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37138 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755223AbaAVPOu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:14:50 -0500
From: Chris Mason <clm@fb.com>
To: "mgorman@suse.de" <mgorman@suse.de>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Thread-Topic: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Thread-Index: AQHPFx61ZXTlm16UX0ihGnyWT2seDpqRAjIAgABfbwA=
Date: Wed, 22 Jan 2014 15:14:39 +0000
Message-ID: <1390403770.1198.4.camel@ret.masoncoding.com>
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com>
	 <20140122093435.GS4963@suse.de>
In-Reply-To: <20140122093435.GS4963@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="utf-7"
Content-ID: <A3A192EEA1328F45A63684F81E0C08D7@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-22_05:2014-01-22,2014-01-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 09:34 +-0000, Mel Gorman wrote:
+AD4- On Tue, Jan 21, 2014 at 10:04:29PM -0500, Ric Wheeler wrote:
+AD4- +AD4- One topic that has been lurking forever at the edges is the current
+AD4- +AD4- 4k limitation for file system block sizes. Some devices in
+AD4- +AD4- production today and others coming soon have larger sectors and it
+AD4- +AD4- would be interesting to see if it is time to poke at this topic
+AD4- +AD4- again.
+AD4- +AD4- 
+AD4- 
+AD4- Large block support was proposed years ago by Christoph Lameter
+AD4- (http://lwn.net/Articles/232757/). I think I was just getting started
+AD4- in the community at the time so I do not recall any of the details. I do
+AD4- believe it motivated an alternative by Nick Piggin called fsblock though
+AD4- (http://lwn.net/Articles/321390/). At the very least it would be nice to
+AD4- know why neither were never merged for those of us that were not around
+AD4- at the time and who may not have the chance to dive through mailing list
+AD4- archives between now and March.
+AD4- 
+AD4- FWIW, I would expect that a show-stopper for any proposal is requiring
+AD4- high-order allocations to succeed for the system to behave correctly.
+AD4- 

My memory is that Nick's work just didn't have the momentum to get
pushed in.  It all seemed very reasonable though, I think our hatred of
buffered heads just wasn't yet bigger than the fear of moving away.

But, the bigger question is how big are the blocks going to be?  At some
point (64K?) we might as well just make a log structured dm target and
have a single setup for both shingled and large sector drives.

-chris



