Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaHKSxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:53:08 -0400
Received: from mail.tmr.com ([64.65.253.246]:59103 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750991AbaHKSxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:53:07 -0400
X-Greylist: delayed 1344 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2014 14:53:06 EDT
Message-ID: <53E910F7.1040806@tmr.com>
Date: Mon, 11 Aug 2014 14:52:39 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120715 Firefox/14.0.1 SeaMonkey/2.11
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        H Peter Anvin <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: early intel microcode update violating alignment rules
References: <20140809231911.GA4843@khazad-dum.debian.net> <20140811102245.GC4236@nazgul.tnic> <20140811131613.GA4541@khazad-dum.debian.net> <20140811140057.GA21693@pd.tnic>
In-Reply-To: <20140811140057.GA21693@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Mon, Aug 11, 2014 at 10:16:13AM -0300, Henrique de Moraes Holschuh wrote:
>> On Mon, 11 Aug 2014, Borislav Petkov wrote:
>>> On Sat, Aug 09, 2014 at 08:19:11PM -0300, Henrique de Moraes Holschuh wrote:
>>>> Is there a way to fix this in the kernel for the BSP?
>>>
>>> I think you're looking at this the wrong way around. :-) The thing that
>>> needs fixing is the SDM since some CPUs seem to accept 16-byte unaligned
>>> microcode just fine.
>>
>> I often wonder how much of the Intel SDM is really a fairy tale...  it
>> certainly has enough legends from times long past inside ;-)  But just like
>> old stories, should you forget all about them, they sometimes grow fangs
>> back and get you when you're least prepared.
>>
>> Now, seriously, we're neither aligning the thing, nor checking any of it for
>> alignment, so userspace can mess with us at will.  Unless it is trying to be
>> actively malicious, we'll get 4-byte alignment out of userspace for the data
>> inside the early initramfs (assuming the use of the common cpio tools: GNU
>> cpio and GNU pax), but that's it.
>>
>> I can easily propose fixes to reject incorrectly aligned data (and will do
>> so), but you *really* don't want to know the kind of crap I came up with to
>> try to align the microcode update for the BSP: Standard Lovecraftian Mythos
>> Safety Procedures apply!  So I am turning to you for ideas...
>
> It seems to me you're looking for issues where there are none. We simply
> have to ask Intel people what's with the 16-byte alignment and fix
> the SDM, apparently. If the processor accepts the non-16-byte-aligned
> update, why do you care?
>
Because if the requirement is enforced in some future revision, and updates then 
fail in some insane way, the vendor is justified in claiming "I told you so."

Don't suppose you have anything in memory right after the microcode which you 
could put on the stack (15 bytes) slide the image up into alignment, load it, 
and put everything back. Haven't looked at the code or data, just tossing out an 
idea I used for something else back when.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
