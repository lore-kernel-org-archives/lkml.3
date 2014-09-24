Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaIXQtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:49:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1087 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbaIXQtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:49:52 -0400
Message-ID: <5422F62C.30205@fb.com>
Date: Wed, 24 Sep 2014 12:49:48 -0400
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: add helper to read kernel_stack functions
References: <1411574609-12129-1-git-send-email-jbacik@fb.com> <20140924121234.066bd249@gandalf.local.home>
In-Reply-To: <20140924121234.066bd249@gandalf.local.home>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-24_07:2014-09-24,2014-09-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.05312336523755e-09 kscore.compositescore=0
 circleOfTrustscore=22.6900859407804 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409240168
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 12:12 PM, Steven Rostedt wrote:
> On Wed, 24 Sep 2014 12:03:29 -0400
> Josef Bacik <jbacik@fb.com> wrote:
>
>> The way the ftrace kernel_stack event is handled doesn't work right with the
>> normal event reading stuff in python.  The raw buffer read stuff expects the
>> size of the event to be non-zero, but in the case of kernel_stack the caller
>> array is 0 and we are given a size field
>>
>> 	field:int size;	offset:8;	size:4;	signed:1;
>> 	field:unsigned long caller;	offset:16;	size:0;	signed:0;
>>
>> This screws up python becuase it uses the size field to indicate how much of the
>> memory buffer is there to read, which in this case is 0.  This makes it
>> impossible to actually read the caller array from python.  So add a new c
>> binding to specially read the addr array and go ahead and look up the function
>> names for the addr and return those strings.  With this I can now pull the
>> function names for a kernel_stack event from the python library.  Thanks,
>
> No need to add "Thanks" to a change log ;-)

git log --author="Josef Bacik" --author="Josef Whiter" \
	| grep "Thanks," | wc -l
540
git log --author="Josef Bacik" --author="Josef Whiter" --oneline \
	| wc -l
688

Old habits ;).

>
> Will this still work if we convert the kernel_stack to be the same as
> the other dynamic_arrays?
>
> I'm assuming so, as there doesn't seem to be anything here that looks
> specific to the kernel_stack event, and we wouldn't want to break the
> other events.
>
> I just want to make sure you are testing both formats.
>

It should work which is why I went ahead and sent it, but I'm fixing to 
do the kernel side now and I'll test with that and if it doesn't work 
I'll send a v2.  Thanks,

Josef

