Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965435AbaDJDw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:52:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31058 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965162AbaDJDwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:52:53 -0400
Message-ID: <5346158B.90005@fb.com>
Date: Wed, 9 Apr 2014 21:52:43 -0600
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
References: <1397018647.3671.123.camel@pasglop> <53454CBC.9060905@fb.com>	 <1397087273.3671.150.camel@pasglop> <1397088144.3671.155.camel@pasglop>	 <5345F476.2000602@fb.com> <1397093815.3671.156.camel@pasglop>	 <5346012A.50901@fb.com> <1397100937.3671.160.camel@pasglop>
In-Reply-To: <1397100937.3671.160.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-09_05:2014-04-09,2014-04-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=7.04991620636974e-15 kscore.compositescore=0
 circleOfTrustscore=5.8201264735473 compositescore=0.307752384302029
 urlsuspect_oldscore=0.307752384302029 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.307752384302029 spamscore=0
 recipient_to_sender_domain_totalscore=16 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404100060
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-09 21:35, Benjamin Herrenschmidt wrote:
> On Wed, 2014-04-09 at 20:25 -0600, Jens Axboe wrote:
>> On 2014-04-09 19:36, Benjamin Herrenschmidt wrote:
>>> On Wed, 2014-04-09 at 19:31 -0600, Jens Axboe wrote:
>>>> OK, I think we're seeing different symptoms of the same bug. Stay
>>>> tuned, will have something for you to test shortly, I hope.
>>>
>>> Ah thanks. I'll defer the bisection then (it's painful on that machine
>>> for various reasons....)
>>
>> Can you try with these two patches applied?
>
> Booted to login prompt once ... and twice. Much better ! :-)

Excellent! I was hoping it was the same bug :-)
I'll amend the commit and add your tested-by.

> Not sure if it's related, but in the "good" boots (with the patch),
> I see a truckload of:
>
> systemd-udevd[3264]: starting version 204
> sr 2:6:0:0: [sr0]
> Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sr 2:6:0:0: [sr0]
> Sense Key : Illegal Request [current]
> sr 2:6:0:0: [sr0]
> Add. Sense: Logical block address out of range
> sr 2:6:0:0: [sr0] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> end_request: critical target error, dev sr0, sector 0
> Buffer I/O error on device sr0, logical block 0
> [  OK  ] Started udev Kernel Device Manager.
> sr 2:6:0:0: [sr0]
> Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sr 2:6:0:0: [sr0]
> Sense Key : Illegal Request [current]
> sr 2:6:0:0: [sr0]
> Add. Sense: Logical block address out of range
> sr 2:6:0:0: [sr0] CDB:
>
>     etc...
>
> I might have a crap coaster in that drive. It doesn't prevent
> the machine from working otherwise, so far...

That does look like just a dud cdrom in the tray.

-- 
Jens Axboe

