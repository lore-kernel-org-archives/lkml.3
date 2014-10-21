Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbaJUMfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:35:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304AbaJUMfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:35:53 -0400
Message-ID: <54464B93.3090808@redhat.com>
Date: Tue, 21 Oct 2014 08:03:31 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] scripts, checkpatch.pl, provide a better output message
 for commit id format [v2]
References: <1413845376-2128-1-git-send-email-prarit@redhat.com>  <1413846680.5407.4.camel@perches.com> <5445AD03.6000901@redhat.com> <1413857461.5407.8.camel@perches.com>
In-Reply-To: <1413857461.5407.8.camel@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/20/2014 10:11 PM, Joe Perches wrote:
> On Mon, 2014-10-20 at 20:46 -0400, Prarit Bhargava wrote:
>>
>> On 10/20/2014 07:11 PM, Joe Perches wrote:
>>> On Mon, 2014-10-20 at 18:49 -0400, Prarit Bhargava wrote:
>>>> I tested this using both lower and upper case 'c' with the following commit
>>>> text:
>>> []
>>>
>>> I think the patch subject be something like:
>>>
>>> "[PATCH] checkpatch: improve commit id/desc style checking in commit message"
>>>
>>> The [v2] goes in the subject like this:
>>>
>>> "[PATCH V2] checkpatch: ..."
>>>
>>>> 11 chars, SHOULD FAIL
>>>> commit 1234567890a
>>>
>>> []
>>>
>>>> ERROR: Please use 12 or more chars for the git commit ID
>>>> commit 1234567890a
>>>
>>> I'd expect these messages to mention something about the
>>> missing commit description too.
>>
>> Hmm ... is that a requirement here?
> 
> Yes
> 
>> Currently checkpatch.pl doesn't complain about that.
> 
> Yes, it does
> 
> $ ./scripts/checkpatch.pl 0001-part-1.patch
> ERROR: Please use 12 or more chars for the git commit ID like: 'commit 01234567890ab ("commit description")'
> #9: 
> commit 1234567, asdf
> 
> ERROR: Please use 12 or more chars for the git commit ID like: 'commit 01234567890ab ("commit description")'
> #11: 
> commit 123457

Oh I see.  I was completely confused by the message.  This is a better example FWIW:

ERROR: Please use 12 or more chars for the git commit ID like: 'commit
01234567890ab ("commit description")'
#13:
commit 1234567890abc

ie) the commit ID is 13 chars, but is missing a description ...

P.
