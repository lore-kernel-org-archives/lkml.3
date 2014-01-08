Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbaAHVOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:14:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62897 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932215AbaAHVNz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:13:55 -0500
From: Chris Mason <clm@fb.com>
To: "muthu.lkml@gmail.com" <muthu.lkml@gmail.com>
CC: "kmo@daterainc.com" <kmo@daterainc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@linux.intel.com" <lkp@linux.intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
Thread-Topic: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
Thread-Index: AQHPCL03PcXQz/ImsUiAzg3MZ0ORWpp4zOEAgAAr4ACAAFVnAIAA8PCAgAGiswA=
Date: Wed, 8 Jan 2014 21:13:47 +0000
Message-ID: <1389215654.23310.39.camel@ret.masoncoding.com>
References: <20140102053101.GA29352@localhost>
	 <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
	 <20140106221036.GE9037@kmo>
	 <CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>
	 <20140107055318.GA19016@localhost>
	 <CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
In-Reply-To: <CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="utf-7"
Content-ID: <0DAC6286D060EA46A5DFA725F90EABC1@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-08_08:2014-01-07,2014-01-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=138.697591113007
 compositescore=0.533125042697551 urlsuspect_oldscore=0.533125042697551
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.533125042697551 spamscore=0
 recipient_to_sender_domain_totalscore=29 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401080127
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 12:15 -0800, Muthu Kumar wrote:
+AD4- Thanks Fengguang. Final patch with added comment. BTW, fengguang
+AD4- mentioned that git-am has trouble with the inline patch and +ACI-quilt
+AD4- import+ACI- worked fine for him...
+AD4- 
+AD4- ------------
+AD4- In btrfs+AF8-end+AF8-bio(), we increment bi+AF8-remaining if is+AF8-orig+AF8-bio. If not,
+AD4- we restore the orig+AF8-bio but failed to increment bi+AF8-remaining for
+AD4- orig+AF8-bio, which triggers a BUG+AF8-ON later when bio+AF8-endio is called. Fix
+AD4- is to increment bi+AF8-remaining when we restore the orig bio as well.
+AD4- 
+AD4- Reported-and-Tested-by: Fengguang wu +ADw-fengguang.wu+AEA-intel.com+AD4-
+AD4- CC: Kent Overstreet +ADw-kmo+AEA-daterainc.com+AD4-
+AD4- CC: Jens Axboe +ADw-axboe+AEA-kernel.dk+AD4-
+AD4- CC: Chris Mason +ADw-clm+AEA-fb.com+AD4-
+AD4- Signed-off-by: Muthukumar Ratty +ADw-muthur+AEA-gmail.com+AD4-
+AD4- 

Reviewed-by: Chris Mason +ADw-clm+AEA-fb.com+AD4-

Jens, please pull this one in.

+AD4- -----------
+AD4-  fs/btrfs/volumes.c +AHw-    8 +-+-+-+-+-+---
+AD4-  1 files changed, 6 insertions(+-), 2 deletions(-)
+AD4- 
+AD4- diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
+AD4- index 37972d5..34aba2b 100644
+AD4- --- a/fs/btrfs/volumes.c
+AD4- +-+-+- b/fs/btrfs/volumes.c
+AD4- +AEAAQA- -5297,9 +-5297,13 +AEAAQA- static void btrfs+AF8-end+AF8-bio(struct bio +ACo-bio, int err)
+AD4-                 if (+ACE-is+AF8-orig+AF8-bio) +AHs-
+AD4-                         bio+AF8-put(bio)+ADs-
+AD4-                         bio +AD0- bbio-+AD4-orig+AF8-bio+ADs-
+AD4- -               +AH0- else +AHs-
+AD4- -                       atomic+AF8-inc(+ACY-bio-+AD4-bi+AF8-remaining)+ADs-
+AD4-                 +AH0-
+AD4- +-                /+ACo-
+AD4- +-                 +ACo- We have original bio now. So increment bi+AF8-remaining to
+AD4- +-                 +ACo- account for it in endio
+AD4- +-                 +ACo-/
+AD4- +-               atomic+AF8-inc(+ACY-bio-+AD4-bi+AF8-remaining)+ADs-
+AD4- +-
+AD4-                 bio-+AD4-bi+AF8-private +AD0- bbio-+AD4-private+ADs-
+AD4-                 bio-+AD4-bi+AF8-end+AF8-io +AD0- bbio-+AD4-end+AF8-io+ADs-
+AD4-                 btrfs+AF8-io+AF8-bio(bio)-+AD4-mirror+AF8-num +AD0- bbio-+AD4-mirror+AF8-num+ADs-
+AD4- 
+AD4- -------------------------------------


