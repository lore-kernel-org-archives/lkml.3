Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3CPBOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 21:14:30 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:56971 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3CPBO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 21:14:29 -0400
Date: Sat, 16 Mar 2013 09:14:17 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, joe@perches.com,
        shangw@linux.vnet.ibm.com, linuxram@us.ibm.com
Subject: Re: [PATCH 2/2] driver-core: remove the duplicate assignment of
 kobj->parent in device_add
Message-ID: <20130316011416.GB5531@weiyang.vnet.ibm.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130307152244.GA15616@weiyang.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031601-8878-0000-0000-0000064E8590
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend it for sytax error in Message-ID]

Sorry all. 

I just found there is a syntax error of Message-ID in the mail sent from my
mutt. So all my reply maybe rejected by the mail server. 

Hope this time the mail can be accepted by the mail server.

Sorry for the noise again.

On Thu, Mar 07, 2013 at 11:22:44PM +0800, Wei Yang wrote:
On Thu, Mar 07, 2013 at 03:49:12PM +0100, Bjørn Mork wrote:
>[ not stripping any quoting to restore context for linux-kernel]
>
>Wei Yang <weiyang@linux.vnet.ibm.com> writes:
>> On Thu, Mar 07, 2013 at 12:33:19PM +0100, Bjørn Mork wrote:
>>>Wei Yang <weiyang@linux.vnet.ibm.com> writes:
>>>
>>>> kobject_add() will setup the kobject parent correctly.
>>>>
>>>> This patch removes the redundant code.
>>>>
>>>> Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
>>>> Reviewed-by: Ram Pai <linuxram@us.ibm.com>
>>>> Reviewed-by: Gavin Shan <shangw@linux.vnet.ibm.com>
>>>> ---
>>>>  drivers/base/core.c |    4 +---
>>>>  1 files changed, 1 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>>>> index 369ae4e..6b0a859 100644
>>>> --- a/drivers/base/core.c
>>>> +++ b/drivers/base/core.c
>>>> @@ -1024,8 +1024,6 @@ int device_add(struct device *dev)
>>>>  
>>>>  	parent = get_device(dev->parent);
>>>>  	kobj = get_device_parent(dev, parent);
>>>> -	if (kobj)
>>>> -		dev->kobj.parent = kobj;
>>>>  
>>>>  	/* use parent numa_node */
>>>>  	if (parent)
>>>> @@ -1033,7 +1031,7 @@ int device_add(struct device *dev)
>>>>  
>>>>  	/* first, register with generic layer. */
>>>>  	/* we require the name to be set before, and pass NULL */
>>>> -	error = kobject_add(&dev->kobj, dev->kobj.parent, NULL);
>>>> +	error = kobject_add(&dev->kobj, kobj, NULL);
>>>>  	if (error)
>>>>  		goto Error;
>>>
>>>
>>>You've submitted this exact same patch before and Greg asked a couple of
>>>questions about it: https://lkml.org/lkml/2013/1/25/599
>>>
>>>If this is a resubmission, then it would sure be nice if that was clear
>>>from the subject and on.  And I believe any previously asked questions
>>>should be answered in some way.  I see that you have responded to one of
>>>them by moving part of the commit message to the cover letter, but still
>>>without any answer to the question.
>>>
>>>To me this looks like you completely ignored Greg's review questions. Is
>>>that so?
>>
>> Bjør,
>>
>> Thanks for your response. 
>>
>> In my mail box, I just see one mail from Greg and replied. Below is my screen
>> in my mutt. You see I replied and wait for the further comment for several
>> days and send out another reply on Feb 02. Well not receive further comment.
>>
>> 976     Jan 23 Wei Yang        (  37) [PATCH] driver-core: remove the duplicate assignment of kobj->parent in device_add
>> 977 r   Jan 25 Greg KH         (  17) `->
>> 978 r   Jan 28 Wei Yang        (  43)   `->
>> 979     Feb 02 Wei Yang        (  52)     `->
>>
>> Hmm... I am confused with this, maybe my mail box get some problem.
>> Could you see this mail? Or if someone could see this mail, would you please
>> reply so that I will be sure that I have really sent it out .
>>
>> BTW, no one see my reply? I looked in the url you mentioned, really not see my
>> reply. I am sorry for that. 
>
>I cannot answer where your reply may have gone.  I do however note that
>this reply to me went to every address on the CC list *except*
>linux-kernel@vger.kernel.org.  Why?  That would make it appear as you
>never answered me to 99.999997% of the linux-kernel readers...

I am not sure. Maybe this is my mistake. Thanks for pointing out.

>
>Anyway, the main point is really not whether your mail went anywhere or
>not.  If this was indeed an intentional resend, then I do expect it to
>say so and to contain information about how previous review comments
>were resolved.  Most people would not rememeber your answer even it was
>sent to the mailing list.
>

Thank you. Hmm, last time Greg asked some question about how my patch works
and why I want to do this change. Since the mail was lost, we didn't continue
the discussion. 

The last reply, which is not sent out, is attached below. So that we can
continue the discussion and get more feedback. Hope this time the mail will
not be lost.

--------------------------------------------------------------------------------
Greg, 

Thanks for your reply. My explanation below.

On Fri, Jan 25, 2013 at 12:32:56PM -0800, Greg KH wrote:
>On Wed, Jan 23, 2013 at 01:58:30PM +0800, Wei Yang wrote:
>> kobject_add() will setup the kobject parent correctly.
>
>How so?

The assignment of kobj->parent happens in kobject_add_varg, which is called by
kobject_add.

>
>> This patch removes the redundant code.
>
>I don't know, how is it redundant?  What is this causing?  Is it somehow
>slowing things down?

I thought the assignment of kobj->parent happens twice. The first time is in the
device_add, and the second time is in kobject_add/kobject_add_varg.

This patch tried to remove the first time of assignment. 

I guess this will not have big impact on the performance, this is just a code 
refine.

>
>> Tested on Lenovo T420.
>
>How?

After applying the patch, the system could bootup successfully and the
/sys/devices has the same hierachy as before.

>
>I don't know about this patch, sorry.
>
>greg k-h

>
>
>Bjørn

-- 
Richard Yang
Help you, Help me

-- 
Richard Yang
Help you, Help me

