Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965180AbaLKV6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:58:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49477 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964837AbaLKV6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:58:14 -0500
Date: Thu, 11 Dec 2014 16:57:32 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: frequent lockups in 3.18rc4
To: Sasha Levin <sasha.levin@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?q?D=E2niel?= Fraga <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <1418335052.4845.17@mail.thefacebook.com>
In-Reply-To: <548A122C.8000906@oracle.com>
References: <20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<1417806247.4845.1@mail.thefacebook.com>
	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<548A122C.8000906@oracle.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-11_05:2014-12-11,2014-12-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.77555756156289e-16 kscore.compositescore=0
 circleOfTrustscore=120.659590407225 compositescore=0.140620555742602
 urlsuspect_oldscore=0.140620555742602 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.140620555742602 spamscore=0
 recipient_to_sender_domain_totalscore=8 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412110206
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 4:52 PM, Sasha Levin <sasha.levin@oracle.com> 
wrote:
> On 12/11/2014 04:49 PM, Linus Torvalds wrote:
>>  On Thu, Dec 11, 2014 at 6:54 AM, Dave Jones <davej@redhat.com> 
>> wrote:
>>>  >
>>>  > So either one of those 'good's actually wasn't, or I'm just 
>>> cursed.
>>  Even if there was a good that wasn't, that last "bad"  
>> (6f929b4e5a02)
>>  is already sufficient just on its own to say that likely v3.16 
>> already
>>  had the problem.
>> 
>>  Just do
>> 
>>     gitk v3.16..6f929b4e5a02
>> 
>>  and cry.
>> 
>>  (or "git diff --stat -M v3.16...6f929b4e5a02" to see what that 
>> commit
>>  brought in from the common ancestor).
>> 
>>  So I'd call that bisect a failure, and your "v3.16 is fine" is
>>  actually suspect after all. Which *might* mean that it's some 
>> hardware
>>  issue after all. Or there are multiple different problems, and while
>>  v3.16 was fine, the problem was introduced earlier (in the common
>>  ancestor of that staging tree), then fixed for 3.16, and then
>>  re-introduced later again.
> 
> Is it possible that Dave and myself were seeing the same problem after
> all?
> 
> I'll go bisect it even further back...

For both of you, I'm curious how long 3.18 lasts if you turn off the 
serial console (and netconsole) completely.

-chris



