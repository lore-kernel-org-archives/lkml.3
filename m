Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab3GOVt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:49:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50488 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3GOVt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:49:57 -0400
Message-ID: <51E46E55.7090909@infradead.org>
Date: Mon, 15 Jul 2013 14:49:09 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: update git pull info in SubmittingPatches
References: <1373923096-25674-1-git-send-email-paul.gortmaker@windriver.com> <51E46A4D.6060108@infradead.org> <51E46C3B.5020104@windriver.com>
In-Reply-To: <51E46C3B.5020104@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/13 14:40, Paul Gortmaker wrote:
> On 13-07-15 05:31 PM, Randy Dunlap wrote:
>> On 07/15/13 14:18, Paul Gortmaker wrote:
>>> The info in this section was overdue for an update; it had manual
>>> individual steps listed for collecting the information that a
>>> pull request should contain, and no mention of having a proper
>>> overall summary in the pull request that could be used for a
>>> merge commit.
>>>
>>> There are other chunks of this file that need updates to match
>>> current git workflows, but giant wholesale updates are more likely
>>> to get caught up in bike shedding discussions over small details,
>>> so lets start somewhere and attack the problem piece-wise.
>>>
>>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>>
>> Did some "git <command>" create this patch?
> 
> git format-patch -p ....
> 
>> It is missing <quote>
>>   - A marker line containing simply "---".
>> </quote> just after the S-O-B line.
> 
> Not missing, just optional, and only required when you want to
> temporarily pass on some transient information outside of the
> commit log, such as diffstat, which I'd intentionally opted out
> of here.

I didn't know that.
I guess that you can also fix that part of SubmittingPatches some day.

> 
> Paul.
> --
> 
>>
>>
>>>
>>> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
>>> index 6e97e73..6102da9 100644
>>> --- a/Documentation/SubmittingPatches
>>> +++ b/Documentation/SubmittingPatches
>>> @@ -590,33 +590,32 @@ See more details on the proper patch format in the following
>>>  references.
>>>  
>>>  
>>> -16) Sending "git pull" requests  (from Linus emails)
>>> -
>>> -Please write the git repo address and branch name alone on the same line
>>> -so that I can't even by mistake pull from the wrong branch, and so
>>> -that a triple-click just selects the whole thing.
>>> -
>>> -So the proper format is something along the lines of:
>>> -
>>> -	"Please pull from
>>> -
>>> -		git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus
>>> -
>>> -	 to get these changes:"
>>> -
>>> -so that I don't have to hunt-and-peck for the address and inevitably
>>> -get it wrong (actually, I've only gotten it wrong a few times, and
>>> -checking against the diffstat tells me when I get it wrong, but I'm
>>> -just a lot more comfortable when I don't have to "look for" the right
>>> -thing to pull, and double-check that I have the right branch-name).
>>> -
>>> -
>>> -Please use "git diff -M --stat --summary" to generate the diffstat:
>>> -the -M enables rename detection, and the summary enables a summary of
>>> -new/deleted or renamed files.
>>> -
>>> -With rename detection, the statistics are rather different [...]
>>> -because git will notice that a fair number of the changes are renames.
>>> +16) Sending "git pull" requests
>>> +
>>> +For a long time now, the "git request-pull" command has existed,
>>> +and gives a uniform pre-canned text with all the expected information
>>> +within it.  Use this as the basis of your pull request e-mail, and
>>> +prefix it with a sensible description of what the overall series
>>> +of commits achieves.  Assume that this text will be used by the
>>> +maintainer in their merge commit of your changes, and hence be part
>>> +of the git history, just like the changelog of each commit.  Use
>>> +the triple dash described above to separate the merge commit text
>>> +in the top of your mail from the output from "git request-pull".
>>> +
>>> +You are strongly discouraged against manually creating your own
>>
>>                     discouraged from
>> (I would say, but no big deal.)
>>
>>> +pull request text.  Doing so just increases the odds of having
>>> +a typo in the repo location, the branch name, or other missing
>>> +information.  In addition to creating all the required text output,
>>> +the command also validates that your commits are actually reachable
>>> +at the specified location, ensuring you don't waste the maintainer's
>>> +time with having to hunt around trying find the location that you
>>> +really meant.
>>> +
>>> +Your mail subject should be prefixed with "[GIT PULL]" and also
>>> +mention the subsystem it is for, and if possible a very brief
>>> +theme of what the changes achieve, e.g.
>>> +
>>> +   "[GIT PULL] x86: Remove uniprocessor support"
>>
>> Lots of pull requests $Subject line also includes a kernel version number
>> that the pull is for, e.g.,
>>
>> [GIT pull] x86 updates for 3.11
>>
>> I find that helpful in searching.  IOW, I would prefer to see that instead
>> of 12 emails with the same subject of
>>
>> [GIT pull] x86 updates
>>
>> for kernel versions 3.0 thru 3.11.
>>
>>>  
>>>  -----------------------------------
>>>  SECTION 2 - HINTS, TIPS, AND TRICKS
>>>
>>
>>


-- 
~Randy
