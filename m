Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab3CIJOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 04:14:23 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:34392 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab3CIJOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 04:14:19 -0500
Message-ID: <513AFD66.3030404@suse.cz>
Date: Sat, 09 Mar 2013 10:14:14 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 8250.nr_uarts broken in 3.7
References: <20130307231242.GC4280@kroah.com> <20130308010140.GJ13719@hansolo.jdub.homelinux.org> <20130308013923.GA12474@kroah.com> <20130308212722.GL13719@hansolo.jdub.homelinux.org> <513A6A65.9050706@suse.cz> <20130308224950.GM13719@hansolo.jdub.homelinux.org> <513A6D1F.5000202@suse.cz> <513A6FD4.7000506@suse.cz> <513A70CF.9010800@suse.cz> <20130308232809.GO13719@hansolo.jdub.homelinux.org> <20130308234404.GP13719@hansolo.jdub.homelinux.org>
In-Reply-To: <20130308234404.GP13719@hansolo.jdub.homelinux.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2013 12:44 AM, Josh Boyer wrote:
> On Fri, Mar 08, 2013 at 06:28:09PM -0500, Josh Boyer wrote:
>> On Sat, Mar 09, 2013 at 12:14:23AM +0100, Jiri Slaby wrote:
>>> On 03/09/2013 12:10 AM, Jiri Slaby wrote:
>>>> On 03/08/2013 11:58 PM, Jiri Slaby wrote:
>>>>> On 03/08/2013 11:49 PM, Josh Boyer wrote:
>>>>>> On Fri, Mar 08, 2013 at 11:47:01PM +0100, Jiri Slaby wrote:
>>>>>>> Yeah, I agree this is ugly. Just re-definining MODULE_PARAM_PREFIX at
>>>>>>> the end of the file should do the trick (followed by
>>>>>>> "module_param(nr_uarts, uint, 0644)").
>>>>>>
>>>>>> For some reason, I thought I had tried that.  Maybe I didn't.  I'll look
>>>>>> into it again.
>>>>>
>>>>> I see. Because we would re-define some global variables. What if we put
>>>>> module_param into a function?
>>>>
>>>> Something like this?
>>>> #ifdef MODULE
>>
>> I don't think you want this surrounded in #ifdef MODULE, do you?  That
>> won't let people building the driver into the kernel continue to use
>> 8250.<whatever> on the kernel command line.

Yes, you're right. I sort of thought the prefix is not used for
non-modules. But it is.

>>>> static void __unused splat(void) {
>>>
>>> I meant __used. It should make no difference though.
>>>
>>>> #       undef MODULE_PARAM_PREFIX
>>>> #       define MODULE_PARAM_PREFIX "8250."
>>>>         module_param_cb(nr_uarts, &param_ops_uint, &nr_uarts, 0644);
>>>>         ...
>>>> }
>>>> #endif
>>>>
>>>> Not nice, but should work. The other way is to have those in a separate
>>>> file linked to 8250 (to avoid re-definition errors).
>>
>> Ew.  I'll try the function first.
> 
> OK, the function (without the surrounding ifdef) seems to be working OK.
> I'll do a bit more testing and send out a v2 in a bit.
> 
> Thanks for the tip.  It's still not pretty, but at least I don't feel
> ashamed about it.

I'm thinking about deprecating the 8250_core.* in some way. Better
sooner than later. The view of having both of them with that hack in the
kernel forever drives me bananas.

-- 
js
suse labs
