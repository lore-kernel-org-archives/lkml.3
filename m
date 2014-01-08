Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbaAHUvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:51:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14856 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750839AbaAHUvq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:51:46 -0500
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
Thread-Index: AQHPCL03PcXQz/ImsUiAzg3MZ0ORWpp4zOEAgAAr4ACAAFVnAIAA8PCAgAAEF4CAAA6/AIABdgMAgAADfgCAAAZsgIAABqAAgAADIIA=
Date: Wed, 8 Jan 2014 20:51:38 +0000
Message-ID: <1389214325.23310.34.camel@ret.masoncoding.com>
References: <20140102053101.GA29352@localhost>
	 <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
	 <20140106221036.GE9037@kmo>
	 <CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>
	 <20140107055318.GA19016@localhost>
	 <CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
	 <1389126617.23310.19.camel@ret.masoncoding.com>
	 <CAFR8ueezG4U5ULcp0ayhY690RUE7280UL68d55+tGCqDW9A1Kg@mail.gmail.com>
	 <1389210102.23310.31.camel@ret.masoncoding.com>
	 <CAFR8uefXjN_nzHWsTF=-PxNPDMWMj5Hw+ueFYQwa8-qBEGMGTw@mail.gmail.com>
	 <1389212231.23310.33.camel@ret.masoncoding.com>
	 <CAFR8uec00zThzs5Q21ySG90shQHVxbRZDGrYBPrdn1KbNCQ_vw@mail.gmail.com>
In-Reply-To: <CAFR8uec00zThzs5Q21ySG90shQHVxbRZDGrYBPrdn1KbNCQ_vw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="utf-7"
Content-ID: <8D61A146B31F2A46B7A0C3CE9BDA8E79@fb.com>
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
 definitions=main-1401080126
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-08 at 12:40 -0800, Muthu Kumar wrote:
+AD4- On Wed, Jan 8, 2014 at 12:16 PM, Chris Mason +ADw-clm+AEA-fb.com+AD4- wrote:
+AD4- +AD4- On Wed, 2014-01-08 at 11:54 -0800, Muthu Kumar wrote:
+AD4- +AD4APg- Chris,
+AD4- +AD4APg-
+AD4- +AD4APg- +AFs-    8.336061+AF0- WARNING: CPU: 0 PID: 0 at fs/bio.c:1778 bio+AF8-endio+-0xbe/0x100()
+AD4- +AD4APg- +AFs-    8.336062+AF0- bio+AF8-endio: bio for (unknown) without endio
+AD4- +AD4APg-
+AD4- +AD4APg- This is my recent change to avoid memory leak in bio+AF8-endio. But I
+AD4- +AD4APg- think the problem is higher up, most likely bio+AF8-endio is called twice
+AD4- +AD4APg- on the same bio (which was freed before).
+AD4- +AD4APg-
+AD4- +AD4-
+AD4- +AD4- I think these are just two separate problems.  Lets ignore the WARN+AF8-ON
+AD4- +AD4- for now.
+AD4- +AD4-
+AD4- 
+AD4- Not really... the BUG that is triggered:
+AD4- 
+AD4- kernel BUG at fs/bio.c:523+ACE-
+AD4- 
+AD4- It is in bio+AF8-put() (added to bio+AF8-endio() as part of recent change)
+AD4- which gets an already freed bio.
+AD4- 

Oh+ACE- I see.  Let me try with that one reverted.  Thanks+ACE-

-chris

