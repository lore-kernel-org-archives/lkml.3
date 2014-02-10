Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750890AbaBJFBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 00:01:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35255 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaBJFBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 00:01:40 -0500
Message-ID: <52F85D2F.6010501@infradead.org>
Date: Sun, 09 Feb 2014 21:01:35 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gene Heskett <gheskett@wdtv.com>
CC: Ken Moffat <zarniwhoop@ntlworld.com>, linux-kernel@vger.kernel.org
Subject: Re: make oldfonfig broken.
References: <1391971686-9517-1-git-send-email-richard@nod.at> <201402092314.58129.gheskett@wdtv.com> <52F852DA.9040407@infradead.org> <201402092332.32439.gheskett@wdtv.com>
In-Reply-To: <201402092332.32439.gheskett@wdtv.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 08:32 PM, Gene Heskett wrote:
> On Sunday 09 February 2014, Randy Dunlap wrote:
>> On 02/09/2014 08:14 PM, Gene Heskett wrote:
>>> On Sunday 09 February 2014, Randy Dunlap wrote:
>>>> On 02/09/2014 07:46 PM, Gene Heskett wrote:
>>>>> On Sunday 09 February 2014, Randy Dunlap wrote:
>>>>>> On 02/09/2014 07:07 PM, Ken Moffat wrote:
>>>>>>> On Sun, Feb 09, 2014 at 06:05:41PM -0500, Gene Heskett wrote:
>>>>>>>> On Sunday 09 February 2014, Paul Bolle wrote:
>>>>>>>>> Feel free to open a new thread, with the relevant details, and
>>>>>>>>> involve the relevant people and lists. I have no idea what you're
>>>>>>>>> going on about and could not care less (in the context of this
>>>>>>>>> thread).
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Paul Bolle
>>>>>>>>
>>>>>>>> Been tried, got zero response.  Frankly, posting just to lkml,
>>>>>>>> hoping the revalent people see it, is beginning to act like
>>>>>>>> posting to a black hole.
>>>>>>>>
>>>>>>>  I saw one response to you, from Randy Dunlap, asking for more
>>>>>>>
>>>>>>> information : https://lkml.org/lkml/2014/2/8/153
>>>>>>
>>>>>> wow, I don't know how I saw this message (thanks, Ken),
>>>>>> but replying to this patch was NOT the right thing to do, Gene.
>>>>>>
>>>>>> Just reply to my request and I'll be glad to look into it.
>>>>>>
>>>>>>>  After your posts a few days ago, I'm tempted to suggest you check
>>>>>>>
>>>>>>> your spam filters, and also any mail files your virus scanner might
>>>>>>> have quarantined.  But it is also possible that you just haven't
>>>>>>> received it - email is like that.
>>>>>>>
>>>>>>> ط¤آ¸en
>>>>>
>>>>> Spam and viri filters watched carefully.  I also use mailfilter, and
>>>>> watch its logs full time for FP's.
>>>>
>>>> Still -- this ATSC problem should not be part of a reply to the Remove
>>>> DEPRECATED patch.
>>>
>>> True.  But I got some attention.
>>>
>>>>> And I didn't reply because the question seemed way too broad, almost
>>>>> as if
>>>>
>>>> what question seemed to broad?
>>>
>>> You wanted to see "a" config, but I wanted to show the diffs. Also
>>> yesterday I hadn't gone thru what I have yet to see where it falls
>>> apart.
>>>
>>>>> my lament wasn't read.  That and the mail server doesn't like big
>>>>
>>>> what mail server?  yours?  wdtv?  vger.kernel.org certainly has no
>>>> problem with them.
>>>
>>> I have gotten bounced from lkml because a screen shot pix of a failed
>>> boot was too big.  Perhaps 18 months or so.  It was big, from a 10
>>> megapixel camera.
>>>
>>>>> attachments. So rather than reply to the list, I'll excise some of
>>>>> the addresses that bounce from a reply_all or don't like me, and
>>>>> send the .config from a 3.019 build which seems ok, but by the time
>>>>> that config is run thru a make oldconfig at 3.8.2, most all the
>>>>> media, ATSC and DVB stuff is gone.  So I'll attach that one too. 
>>>>> The later file grew 22kb, but wholesale parts of the first one are
>>>>> missing from the 2nd.
>>>>
>>>> Gene, I want to make sure where you are saying the problem is.
>>>> Is it going directly from 3.019 to 3.8.2, with no intervening kernel
>>>> versions?
>>>
>>> No, one intermediate step in this case.
>>>
>>> I started with 3.0.19, which was fine, took that one to 3.2.40, and
>>> that one to 3.8.2 because I don't have anything between those here. 
>>> Not exactly a step by step.
>>
>> and when you go from one kernel version to the next, do you use
>>
>> $ make oldconfig
>> and answer all of its questions, or do you use
> 
> I generally answer all its questions, or take the default by hitting enter, 
> but I do read all its questions.
> 
>> $ yes '' | make oldconfig
> 
> Never done that in all these years.
> 
>> or some other variant?  (I guess in your super build script.)
> 
> This is long before my "super script" gets fired off.
> 
> And that part is actually working well, run it as root, do a grub-update 
> and reboot.
> 
> Cheers, Gene
> 

You need to have a Kconfig symbol named DVB_CORE enabled.

In 3.8.2 (and likely previously, but not in 3.2.40),
DVB_CORE depends on having both MEDIA_SUPPORT and MEDIA_DIGITAL_TV_SUPPORT
enabled.  Your .confile file  has MEDIA_SUPPORT enabled but not
MEDIA_DIGITAL_TV_SUPPORT.

In your 3.2.40 kernel source tree, just edit your .config file and delete the line
that says:
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set

then run [1]
$ make oldconfig
and it will ask you how to set the Kconfig symbol.  Tell it 'y'.

and if you can find this line in your .config file:
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

delete it. Run 'make oldconfig' again if you did so at [1] above.
For this Kconfig question:
  Autoselect tuners and i2c modules to build (MEDIA_SUBDRV_AUTOSELECT),
answer N.
Then you can select all of the tuners and frontends that you want.
There are LOTS of them to choose from.

IIRC, this all happened because someone decided that they could make the AUTOSELECT
driver feature Better!  ugh.

Good luck. Let me know if you need more guidance.


-- 
~Randy
