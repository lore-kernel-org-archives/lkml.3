Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab3D1RdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 13:33:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59011 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab3D1RdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 13:33:06 -0400
Message-ID: <517D5D3A.8070505@zytor.com>
Date: Sun, 28 Apr 2013 10:32:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH v2] x86: make DR*_RESERVED unsigned long
References: <CA+55aFwpLu0qNms=hkQr43yqD0K9DgESNm91OEWKT1ZuT8MU6Q@mail.gmail.com> <20130424072630.GB1780@gmail.com> <20130424170702.GA1867@redhat.com> <5178282D.9030902@zytor.com> <20130425144818.GA25921@redhat.com> <20130426163802.GA30351@redhat.com> <517AAED5.7040400@zytor.com> <20130426171526.GA30875@redhat.com> <20130427144537.GA24256@redhat.com> <20130428005814.GB10354@somewhere> <20130428172731.GA26169@redhat.com>
In-Reply-To: <20130428172731.GA26169@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2013 10:27 AM, Oleg Nesterov wrote:
> On 04/28, Frederic Weisbecker wrote:
>>
>> On Sat, Apr 27, 2013 at 04:45:37PM +0200, Oleg Nesterov wrote:
>>>
>>> -/* Define reserved bits in DR6 which are always set to 1 */
>>> -#define DR6_RESERVED	(0xFFFF0FF0)
>>> +#define DR6_MASK	(0xF00FU)	/* Everything else is reserved */
>>
>> I'm personally fine either with that or with Peter's suggestion to do:
>>
>> -#define DR6_RESERVED (0xFFFF0FF0)
>> +#define DR6_RESERVED (~0xF00FUL)
> 
> I missed this suggestion...
> 
> Yes, and this allows to kill ifdef too.
> 
>> If this should stay stable UAPI,
> 
> I do not know, but I guess it would be safer to keep the old define's.
> 
>> I really don't mind.
> 
> Oh, I do not mind too ;)
> 
> OK, please see v3.
> 

Looks good.  However, given the timing, I would think this is 3.11
material unless we have a manifest bug at this point.

I have several bits like this that I'm going to queue up in a separate
tip branch.

	-hpa


