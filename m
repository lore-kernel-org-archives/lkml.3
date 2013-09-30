Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab3I3Bev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:34:51 -0400
Received: from intranet.asianux.com ([58.214.24.6]:47447 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab3I3Bes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:34:48 -0400
X-Spam-Score: -100.8
Message-ID: <5248D4EF.6030002@asianux.com>
Date: Mon, 30 Sep 2013 09:33:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 08/11] rcu: Micro-optimize rcu_cpu_has_callbacks()
References: <20130925012750.GA30601@linux.vnet.ibm.com> <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com> <1380072561-31134-8-git-send-email-paulmck@linux.vnet.ibm.com> <524250A2.3050502@asianux.com> <20130925201640.GZ9093@linux.vnet.ibm.com> <5243A2A3.1050402@asianux.com> <20130926183329.GL9093@linux.vnet.ibm.com> <5244ED9D.5010105@asianux.com> <5247AB94.4080407@asianux.com> <20130929202342.GE19582@linux.vnet.ibm.com>
In-Reply-To: <20130929202342.GE19582@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 04:23 AM, Paul E. McKenney wrote:
> On Sun, Sep 29, 2013 at 12:24:52PM +0800, Chen Gang wrote:
>> On 09/27/2013 10:29 AM, Chen Gang wrote:
>>> On 09/27/2013 02:33 AM, Paul E. McKenney wrote:
>>>> On Thu, Sep 26, 2013 at 10:57:39AM +0800, Chen Gang wrote:
>>>>> On 09/26/2013 04:16 AM, Paul E. McKenney wrote:
>>>>>> On Wed, Sep 25, 2013 at 10:55:30AM +0800, Chen Gang wrote:
>>>>>>>
>>>>>>> Thank you for your whole work, firstly  :-).
>>>>>>>
>>>>>>> And your suggestion about testing (in our discussion) is also valuable
>>>>>>> to me.
>>>>>>>
>>>>>>> I need start LTP in q4. After referenced your suggestion, my first step
>>>>>>> for using/learning LTP is not mainly for finding kernel issues, but for
>>>>>>> testing kernel (to improve my kernel testing efficiency).
>>>>>>>
>>>>>>> When I want to find issues by reading code, I will consider about LTP
>>>>>>> too (I will try to find issues which can be tested by LTP).
>>>>>>
>>>>>> Doing more testing will be good!  You will probably need more tests
>>>>>> than just LTP, but you must of course start somewhere.
>>>>>
>>>>> Give more testing is good, but also mean more time resources cost. If
>>>>> spend the 'cost', also need get additional 'contributions' (not only
>>>>> prove an issue), or the 'efficiency' can not be 'acceptable'.
>>>>>
>>>>> When "I need more tests than just LTP", firstly I need perform this
>>>>> test, and then, also try to send "test case" to LTP (I guess, these
>>>>> kinds of mails are welcomed by LTP).
>>>>>
>>>>> And LTP is also a way to find kernel issues, although I will not mainly
>>>>> depend on it now (but maybe in future), it is better to familiar with it
>>>>> step by step.
>>>>>
>>>>> LTP (Linux Test Project) is one of main kernel mad user at downstream.
>>>>> Tool chain (GCC/Binutils) is one of kernel main mad tools at upstream.
>>>>> If we face to the whole kernel, suggest to use them. ;-)
>>>>
>>>> Yep, starting with just LTP is OK.  But if by this time next year you
>>>> really should be using more than just LTP.
>>>>
>>
>> What I have done is trying to fully use other members contributions, not trying to instead of them.
>>
>>
>> And the reason why I want/try to 'open' my 'ideas' to public:
>>
>>   get more suggestions, and completions from other members.
>>
>>   share my ideas, it can let other members provide more contributions (e.g. I am glad, if find other members also try 'allmodconfig' on all architectures).
>>
>>   If some members replicate me, I will save my current time resources and devote them to another things (which also based on other members contributions).
>>
>>
>> In my opinion:
>>
>>   "Open and Share" are both important and urgent to everyone, although it may not be noticed directly. Like "Air and Water" which God have blessed to everyone.
> 

Firstly, thank you very much for your details reply.


> In a general sense, of course.
> 
> In many specific cases, effective sharing can require quite a bit of
> preparation.  For but one example, in Dipankar's and my case, it took
> about two years of work (mostly Dipankar's work) to get the initial
> implementation of RCU accepted into the Linux kernel.
> 
> In your case, you can invest an average of three days per accepted
> patch if you are to achieve your goal of ten patches accepted per month
> (if I remember correctly).  Of course, not every patch will be accepted,
> which reduces your per-patch time.  For example, if 50% of your patches
> are accepted, you can invest an average of about 1.5 days per patch.
> 
> Of course, investing in learning about test frameworks or specific
> kernel subsystems further reduces your time available per patch.
> 
> But if you don't invest in your learning, you will be limited in what
> you can effectively contribute.  This might be OK, for all I know.
> After all, in the 15 million lines of Linux kernel code, there is
> probably a very large number of point-problems waiting to be fixed.
> 
> But suppose that you run out of easily found point problems?  Or that
> you want to do something more wide-ranging than fixes for point problems?
> What can you do?
> 
> Here are a few options.  If you think more about it, I am sure that you
> can come up with others.
> 
> 1.	Put the ten-patches-per-month quota aside for a month (or two or
> 	three or whatever is required and appropriate).  Spend this time
> 	studying a given kernel subsystem or a given test framework.
> 	(Which kernel subsystem?  The best candidates would be those
> 	having bugs but no active maintainer, but which you have the
> 	hardware needed to adequately test.)
> 
> 2.	Add a review and/or test component to your monthly quota, so
> 	that a given patch could be substituted for by some number of
> 	Reviewed-by or Tested-by flags.  Of course, this gives your
> 	a chicken-and-egg problem because you cannot adequately review
> 	or test without some understanding of the subsystem in question.
> 	(At least not efficiently enough to get enough Tested-by or
> 	Reviewed-by flags.)
> 
> 3.	Set aside a fixed amount of time each week (or each month) to
> 	learn.  This time needs to be a contiguous block of at least
> 	four hours.  If you focus your learning appropriately, you might
> 	be able to contribute more deeply to whatever you learned about
> 	over time.
> 
> 	For whatever it is worth, just staring at code is for most people
> 	an inefficient way to learn.  Exercising the code using tools
> 	like ftrace or userspace scaffolding can help speed up the
> 	learning.
> 

At least for me, what you said is valuable.

In fact, I am just trying in this way for Tool Chain (GCC/Binutils),
and use Linux Kernel as the test object of Tool Chain. ;-)


> 4.	Your idea here...
> 

'Ways' depends on your goal.


For Tool Chain and LTP, I only want to use them for kernel, so I need
familiar with their features details which related with Linux Kernel,
(in fact, GCC is not easy for me, too).

But for Linux Kernel, I want to face the whole kernel (it is my main
goal), so I start from Interface: kernel's upstream (e.g. Tool Chain),
kernel's downstream (e.g. LTP), and Reading Code/Docs.

So what I have done to Linux kernel, is just only starting, it can be
followed with many many next steps.


> Your current approach seems to be to submit patches and hope that the
> maintainer takes it upon himself or herself to teach you.  Unfortunately,
> as you might have noticed, a given maintainer might not have the time
> or energy to take on full responsibility for your education.
> 

In my opinion, teaching and educating are not quite efficient: I am not
graduated from University (no bachelor's degree, not computer science
major, either), although I come from China Zhe Jiang University.

When I send a patch to the related maintainer (or integrator), I don't
intend to let them 'teach' me (it is not quite efficient), I only want
to work together which can improve the whole efficiency.

  e.g. if the maintainers already know about it, we don't need wast time again.
  e.g. if no related maintainer, I should try and let integrator check and provide him/her suggestions for what I have done.



> 							Thanx, Paul
> 
> 
> 

Thanks.
-- 
Chen Gang
