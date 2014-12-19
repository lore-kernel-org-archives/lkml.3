Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaLSPPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:15:15 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42769 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281AbaLSPPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:15:13 -0500
Date: Fri, 19 Dec 2014 10:14:29 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: frequent lockups in 3.18rc4
To: Dave Jones <davej@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Message-ID: <1419002069.13012.4@mail.thefacebook.com>
In-Reply-To: <20141219145528.GC13404@redhat.com>
References: <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
	<CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
	<20141218051327.GA31988@redhat.com>
	<1418918059.17358.6@mail.thefacebook.com>
	<20141218161230.GA6042@redhat.com> <20141219024549.GB1671@redhat.com>
	<CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
	<20141219035859.GA20022@redhat.com> <20141219040308.GB20022@redhat.com>
	<CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
	<20141219145528.GC13404@redhat.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-19_04:2014-12-19,2014-12-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=5 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=145.191669734525
 compositescore=0.160988131301636 urlsuspect_oldscore=0.160988131301636
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.160988131301636 spamscore=5
 recipient_to_sender_domain_totalscore=7 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412190151
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Dec 19, 2014 at 9:55 AM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Dec 18, 2014 at 08:48:24PM -0800, Linus Torvalds wrote:
>  > On Thu, Dec 18, 2014 at 8:03 PM, Dave Jones <davej@redhat.com> 
> wrote:
>  > >
>  > > So the only thing that was on that could cause spinlock overhead
>  > > was DEBUG_SPINLOCK (and LOCK_STAT, though iirc that's not huge 
> either)
>  >
>  > So DEBUG_SPINLOCK does have one big downside if I recall correctly 
> -
>  > the debugging spinlocks are very much not fair. So they don't work
>  > like the real ticket spinlocks. That might have serious effects on 
> the
>  > contention case, with some thread not making any progress due to 
> just
>  > the implementation of the debug spinlocks.
> 
> Wish DEBUG_SPINLOCK disabled, I see the same behaviour.
> Lots of traces spewed, but it seems to run and run (at least so far).

Not quite the same, the spinlocks are gone.

-chris



