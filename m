Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaLBRPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:15:40 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64371 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065AbaLBRPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:15:39 -0500
Date: Tue, 2 Dec 2014 12:14:53 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: frequent lockups in 3.18rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <1417540493.21136.3@mail.thefacebook.com>
In-Reply-To: <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
References: <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com> <m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-02_07:2014-12-02,2014-12-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=120.659590407225
 compositescore=0.140620555742602 urlsuspect_oldscore=0.140620555742602
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.140620555742602 spamscore=0
 recipient_to_sender_domain_totalscore=8 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412020148
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 11:33 AM, Linus Torvalds 
<torvalds@linux-foundation.org> wrote:
> On Tue, Dec 2, 2014 at 6:13 AM, Mike Galbraith 
> <umgwanakikbuti@gmail.com> wrote:
> 
> At the same time, the whole "incapacitated by the rt throttle long
> enough for the hard lockup detector to trigger" commentary about that
> skip_clock_update issue does make me go "Hmmm..". It would certainly
> explain Dave's incomprehensible watchdog messages..

Dave's first email mentioned that he had panic on softlockup enabled, 
but even with that off the box wasn't recovering.

In my trinity runs here, I've gotten softlockup warnings where the box 
eventually recovered.  I'm wondering if some of the "bad" commits in 
the bisection are really false positives where the box would have been 
able to recover if we'd killed off all the trinity procs and given it 
time to breath.

-chris



