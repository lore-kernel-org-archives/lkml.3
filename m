Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbaGKS1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:27:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23145 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbaGKS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:27:35 -0400
Message-ID: <53C02C85.7000304@fb.com>
Date: Fri, 11 Jul 2014 14:27:17 -0400
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] trace-cmd: add the ability to install libtracecmd
References: <1405027367-26570-1-git-send-email-jbacik@fb.com> <20140710185311.5672b6e6@gandalf.local.home>
In-Reply-To: <20140710185311.5672b6e6@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-11_04:2014-07-11,2014-07-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=7.14650560951213e-13 kscore.compositescore=0
 circleOfTrustscore=22.6900859407804 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407110225
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 06:53 PM, Steven Rostedt wrote:
> On Thu, 10 Jul 2014 17:22:45 -0400
> Josef Bacik <jbacik@fb.com> wrote:
>
>> Hello,
>>
>> I'm trying to build some custom tracing tools on top of trace-cmd but they
>> aren't really usefull outside of Facebook so I don't want to shove them into the
>> actual trace-cmd project.  Instead I'd like to be able to just build libtracecmd
>> and install that as well as the necessary header files and just link my tools
>> against that.  I'm shit at userspace stuff like this, so I've just hacked
>> something together that works for me.  I'm mostly hoping somebody will look at
>> the Makefile horribleness that I came up with and tell me how to do it right (or
>> better yet do it for me!)  The second patch just cleans up some stuff to make
>> the shared library more library esque.  Any feedback would be great.  Thanks,
>>
>
> I'm shit at userspace too ;-)  I just like simple makefiles and other
> non "autocrap" stuff.
>
> Anyway, I did plan on getting a libtracecmd out someday (at a bottom of
> a very long todo list), so I'm all game for this. I was hoping to get
> libtraceevent out first. That's now homed in the kernel tools
> directory and I've been porting stuff to and from trace-cmd for that as
> well. But there's still a bit of work on that front.
>
> I'll have to take a look at your patches and see how they are after I
> get some other things out of the way first.
>

Ok I didn't notice the libtracecmd, so I'll send the second patch 
against that since it's just against the event parse stuff.  In reality 
all I need is the event parsing stuff, I just use the libtracecmd to 
open the trace.dat file.  I'll see if I can figure out how to just parse 
the events live without having to record with trace-cmd first and that 
will probably be good enough for me for now, then maybe when I care 
about post-processing trace.dat you will have gotten to the bottom of 
your TODO list.  Thanks,

Josef
