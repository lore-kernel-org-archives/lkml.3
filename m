Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaLCU5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:57:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12823 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbaLCU5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:57:37 -0500
Date: Wed, 3 Dec 2014 15:56:58 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: frequent lockups in 3.18rc4
To: Dave Jones <davej@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <1417640218.11261.2@mail.thefacebook.com>
In-Reply-To: <20141203201112.GB3118@redhat.com>
References: <547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141203190045.GB32005@redhat.com>
	<1417636798.11261.1@mail.thefacebook.com>
	<20141203201112.GB3118@redhat.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-03_08:2014-12-03,2014-12-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=104.155259362634
 compositescore=0.182402046397986 urlsuspect_oldscore=0.182402046397986
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.182402046397986 spamscore=0
 recipient_to_sender_domain_totalscore=7 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412030185
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, Dec 3, 2014 at 3:11 PM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Dec 03, 2014 at 02:59:58PM -0500, Chris Mason wrote:
> 
>  > You've also mentioned a few times where messages stopped hitting 
> the
>  > console?
>  >
>  > commit 5874af2003b1aaaa053128d655710140e3187226
>  > Author: Jan Kara <jack@suse.cz>
>  > Date:   Wed Aug 6 16:09:10 2014 -0700
>  >
>  >     printk: enable interrupts before calling
>  > console_trylock_for_printk()
> 
> Hmm..

Jan Kara has been talking about printk deadlocks for some time.  I 
wouldn't have expected it to get worse since 3.16, but we do have a few 
printk cleanups and fixes in there.

-chris



