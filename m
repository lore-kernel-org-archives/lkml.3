Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbaDJNs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:48:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55253 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbaDJNs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:48:27 -0400
Message-ID: <5346A10B.10003@fb.com>
Date: Thu, 10 Apr 2014 07:47:55 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Brian J King <bjking1@us.ibm.com>
Subject: Re: [BUG] kernel BUG at /.../block/cfq-iosched.c:3145!
References: <1397018647.3671.123.camel@pasglop> <53454CBC.9060905@fb.com>	 <1397087273.3671.150.camel@pasglop> <1397088144.3671.155.camel@pasglop>	 <5345F476.2000602@fb.com> <1397093815.3671.156.camel@pasglop>	 <5346012A.50901@fb.com> <1397100937.3671.160.camel@pasglop>	 <5346158B.90005@fb.com> <1397112333.3671.179.camel@pasglop>
In-Reply-To: <1397112333.3671.179.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-10_03:2014-04-10,2014-04-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.99840144432528e-14 kscore.compositescore=0
 circleOfTrustscore=4.71997498428943 compositescore=0.511273121866876
 urlsuspect_oldscore=0.511273121866876 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.511273121866876 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404100214
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-10 00:45, Benjamin Herrenschmidt wrote:
> On Wed, 2014-04-09 at 21:52 -0600, Jens Axboe wrote:
>> On 2014-04-09 21:35, Benjamin Herrenschmidt wrote:
>>> On Wed, 2014-04-09 at 20:25 -0600, Jens Axboe wrote:
>>>> On 2014-04-09 19:36, Benjamin Herrenschmidt wrote:
>>>>> On Wed, 2014-04-09 at 19:31 -0600, Jens Axboe wrote:
>>>>>> OK, I think we're seeing different symptoms of the same bug. Stay
>>>>>> tuned, will have something for you to test shortly, I hope.
>>>>>
>>>>> Ah thanks. I'll defer the bisection then (it's painful on that machine
>>>>> for various reasons....)
>>>>
>>>> Can you try with these two patches applied?
>>>
>>> Booted to login prompt once ... and twice. Much better ! :-)
>>
>> Excellent! I was hoping it was the same bug :-)
>> I'll amend the commit and add your tested-by.
>
> A colleague was complaining of yet another oddball block related crash
> today on another machine when doing rsync's with upstream (this machine
> booted fine but crashed later on, but then it has less CPUs... maybe
> that's relevant) and these patches fixed it too.

I'm sure it could manifest itself in a lot of weird ways. I'll send it 
upstream this morning, so hopefully should be fixed in mainline shortly.

-- 
Jens Axboe

