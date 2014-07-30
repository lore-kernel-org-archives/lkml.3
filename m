Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaG3QNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:13:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52599 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754689AbaG3QNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:13:05 -0400
Message-ID: <53D91938.6070406@fb.com>
Date: Wed, 30 Jul 2014 12:11:36 -0400
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, Darren Hart <darren@dvhart.com>
Subject: Re: [PATCH] trace-cmd: add trace-record.o to the python shared lib
References: <1405975844-2361-1-git-send-email-jbacik@fb.com>	 <20140721170153.42a0d5d2@gandalf.local.home> <1406033927.32255.33.camel@jlt4.sipsolutions.net>
In-Reply-To: <1406033927.32255.33.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-30_06:2014-07-30,2014-07-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.05312336523755e-09 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997600857122248
 urlsuspect_oldscore=0.997600857122248 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997600857122248 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407300190
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 08:58 AM, Johannes Berg wrote:
> On Mon, 2014-07-21 at 17:01 -0400, Steven Rostedt wrote:
>> Cc'd my python gurus.
>>
>> Acks?
>
>>> When trying to use the python library it was giving me an error about not being
>>> able to resolve tracecmd_stat_cpu.  This is because we weren't linking
>>> trace-record.o to ctracecmd.so.  Fix this in the makefile and now I can import
>>> trace-cmd in python properly.  Thanks,
>
> I guess, I don't see anything wrong with that. I don't usually use
> ctracecmd.so standalone, only as part of trace-cmd, which may explain
> why I didn't see any problem?
>

Maybe?  I'm not sure how it worked for you, with just a normal install I can
load up python and import tracecmd and it blows up immediately.  This is
pointing at the /usr/local/lib/trace-cmd/python stuff, not using it from
trace-cmd directly.  Steve can you take these two patches so I can close out my
internal stuff?  I don't like carrying patches I can't point at an upstream
commit for.  Thanks,

Josef
