Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab3LWFmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:42:12 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:62308 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3LWFmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:42:11 -0500
Message-ID: <52B7CD29.9010806@landley.net>
Date: Sun, 22 Dec 2013 23:42:01 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>
CC: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mmarek@suse.cz, rostedt@goodmis.org
Subject: Re: make oldnoconfig fix?
References: <1386039493.1974.305@driftwood> <52A11604.8000702@linux.intel.com>
In-Reply-To: <52A11604.8000702@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/13 18:10, David Cohen wrote:
> On 12/02/2013 06:58 PM, Rob Landley wrote:
>> On 11/11/2013 12:55:37 PM, David Cohen wrote:
>>> On 11/11/2013 10:13 AM, Yann E. MORIN wrote:
>>>> David, All,
>>>
>>> Hi Yann,
>>>
>>>>
>>>> On 2013-11-11 10:11 -0800, David Cohen spake thusly:
>>>>> Is there a plan to fix 'make oldnoconfig' option?
>>>>> I currently have need to it :)
>>>>> I've tracked a thread fixing 'make olddefconfig' where 'oldnoconfig'
>>>>> option is reported as a known bug, right?
>>>>
>>>> Sorry, I don't understand what your problem is.
>>>
>>> Maybe I assumed it was more 'known' then it actually is :)
>>>
>>>>
>>>> Care to explain in details what problem you have:
>>>>     - what you start with
>>>>     - what you do
>>>>     - what you get
>>>>     - what you expected
>>>
>>> The bug with 'oldnoconfig' is: 'make oldnoconfig' is just an alias to
>>> 'olddefconfig'. Any non-existent config is defined with its default
>>> value instead of 'N'.
>>>
>>> I work with embedded platforms. I need to maintain a set of defconfigs
>>> for different products (customers some times want tailored configs, so
>>> creating a generic one isn't an option always).
>>
>> make allnoconfig KCONFIG_ALLCONFIG=oldconfigfile
>
> I'll give it a try. Thanks!
>
>>
>> I use this trick in http://landley.net/aboriginal/FAQ.html#dev_miniconfig
>>
>> And yes, I submitted it upstream a couple times last decade, with
>> documentation and everything:
>
> You could send it again.

I linked you to three times I sent it:

 >>    https://lwn.net/Articles/160497/
 >>    https://lwn.net/Articles/161086/
 >>    http://lkml.indiana.edu/hypermail/linux/kernel/0607.0/1805.html

Plus I made sure it worked in busybox and uClibc:

http://lists.uclibc.org/pipermail/uclibc/2007-March/038469.html

Other people picked up on it:

http://www.brain-dump.org/blog/show-entry.php?id=109
http://techoverflow.net/blog/2013/07/09/user-mode-linux-for-beginners-part-1-setup-and-first-vm/

Somebody even added it to the Documentation directory a few years back 
(while I wasn't looking):

https://www.kernel.org/doc/Documentation/kbuild/kconfig.txt

The problem was the kbuild maintainer at the time categorically rejected 
the idea in a very long thread. (The replies to that "take 2" lasted two 
weeks.) He was the maintainer, his no was final, so I went off and did 
other things.

> But maybe oldnoconfig would be a better name WRT current standard.
>
> Br, David

As you can see from the rapid response time, I'm a touch overwhelmed of 
late.

I've been offering miniconfig stuff to people for years, but the 
upstream guys had zero interest when I pinged 'em and still don't, last 
I checked. When Linus yanked the giant forest of arm defconfigs he 
decided to have kconfig snippets generate different defconfigs instead 
of miniconfig (which turns out not to be particularly maintainable, but 
oh well).

If somebody else wanted to take the basic concept and push it upstream, 
I'd happily review and ack, but I haven't got it in me to replicate the 
7 years the initramfs guy spent convincing upstream to Do It My Way. I 
scratch my own itch, offer it to other people, they say no, and after 
about the third attempt I go do other things. My todo list runneth over, 
no shortage of other things...

Rob
