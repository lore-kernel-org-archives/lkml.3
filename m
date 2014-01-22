Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaAVUNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:13:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13874 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755685AbaAVUNc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:13:32 -0500
From: Chris Mason <clm@fb.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Thread-Topic: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Thread-Index: AQHPFx61ZXTlm16UX0ihGnyWT2seDpqRAjIAgABNLACAAAa5AIAABq0AgAAFt4CAAB0+gIAABPgAgAALu4CAAALjgIAAAOYAgAAE/YCAAAFJgIAADiiAgAAFggCAAAbvgA==
Date: Wed, 22 Jan 2014 20:13:20 +0000
Message-ID: <1390421691.1198.43.camel@ret.masoncoding.com>
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com>
	 <20140122093435.GS4963@suse.de> <52DFD168.8080001@redhat.com>
	 <20140122143452.GW4963@suse.de> <52DFDCA6.1050204@redhat.com>
	 <20140122151913.GY4963@suse.de>
	 <1390410233.1198.7.camel@ret.masoncoding.com>
	 <1390411300.2372.33.camel@dabdike.int.hansenpartnership.com>
	 <1390413819.1198.20.camel@ret.masoncoding.com>
	 <1390414439.2372.53.camel@dabdike.int.hansenpartnership.com>
	 <52E00B28.3060609@redhat.com>
	 <1390415703.2372.62.camel@dabdike.int.hansenpartnership.com>
	 <52E0106B.5010604@redhat.com>
	 <1390419019.2372.89.camel@dabdike.int.hansenpartnership.com>
	 <20140122115002.bb5d01dee836b567a7aad157@linux-foundation.org>
In-Reply-To: <20140122115002.bb5d01dee836b567a7aad157@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="utf-7"
Content-ID: <4377FC09DDDAD244BD307A4929AD8592@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-22_07:2014-01-22,2014-01-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.997696947966296 urlsuspect_oldscore=0.997696947966296
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997696947966296 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401220146
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 11:50 -0800, Andrew Morton wrote:
+AD4- On Wed, 22 Jan 2014 11:30:19 -0800 James Bottomley +ADw-James.Bottomley+AEA-hansenpartnership.com+AD4- wrote:
+AD4- 
+AD4- +AD4- But this, I think, is the fundamental point for debate.  If we can pull
+AD4- +AD4- alignment and other tricks to solve 99+ACU- of the problem is there a need
+AD4- +AD4- for radical VM surgery?  Is there anything coming down the pipe in the
+AD4- +AD4- future that may move the devices ahead of the tricks?
+AD4- 
+AD4- I expect it would be relatively simple to get large blocksizes working
+AD4- on powerpc with 64k PAGE+AF8-SIZE.  So before diving in and doing huge
+AD4- amounts of work, perhaps someone can do a proof-of-concept on powerpc
+AD4- (or ia64) with 64k blocksize.


Maybe 5 drives in raid5 on MD, with 4K coming from each drive.  Well
aligned 16K IO will work, everything else will about the same as a rmw
from a single drive.

-chris

