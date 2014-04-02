Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbaDBCs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 22:48:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46674 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbaDBCs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 22:48:57 -0400
Message-ID: <533B7A90.6060504@fb.com>
Date: Tue, 1 Apr 2014 20:48:48 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?RnLDqWTDqXJp?= =?UTF-8?B?YyBXZWlzYmVja2Vy?= 
	<fweisbec@gmail.com>,
        Jan Kara <jack@suse.cz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Core block IO bits for 3.15-rc
References: <20140401190502.GA30970@kernel.dk> <CA+55aFzq+mAkUQQkVGe8U8Rd13_Cr1GTcTZfCadjKpF23_OGmA@mail.gmail.com>
In-Reply-To: <CA+55aFzq+mAkUQQkVGe8U8Rd13_Cr1GTcTZfCadjKpF23_OGmA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-01_07:2014-04-01,2014-04-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=8.85849712559055
 compositescore=0.511273121866876 urlsuspect_oldscore=0.511273121866876
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.511273121866876 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404010167
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-01 20:43, Linus Torvalds wrote:
> On Tue, Apr 1, 2014 at 12:05 PM, Jens Axboe <axboe@fb.com> wrote:
>>
>> - Cleanup of the IPI usage from the block layer, and associated helper
>>    code. From Frederic Weisbecker and Jan Kara.
>
> So I absolutely *hate* how this was done.
>
> Why the hell was it mixed in with the block layer code? It's not even
> in some clean separate branch, it's just randomly in the middle of the
> block code, for no obvious reason.
>
> I'm pulling it this time, but quite frankly, next time I see this kind
> of ugly AND TOTALLY POINTLESS layering violation, I will just drop the
> stupid pull request.
>
> If you want to push me cleanups that are to generic code and are in no
> way specific to the block layer, fine. But I want a separate pull
> request that is not in any way mixed up with block code.
>
> In other words, this was NOT OK. This was stupid and wrong, and
> violated all sanity. I can see absolutely no reason why that
> smp_call_function_single_async() renaming and the other cleanups are
> in the block branch. They are totally separate in every single way.
>
> What the hell was going on here?

I agree, it should have been in its own topic branch. No real arguments 
there. And probably should have been split further, so only the block 
required parts ended up in there, and not eg the watchdog parts.

-- 
Jens Axboe

