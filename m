Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3CKOTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:19:14 -0400
Received: from thoth.sbs.de ([192.35.17.2]:17872 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3CKOTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:19:13 -0400
Message-ID: <513DE7DC.8020609@siemens.com>
Date: Mon, 11 Mar 2013 15:19:08 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets
 an INIT
References: <20130311102852.GE31619@redhat.com> <513DBF45.9030803@redhat.com> <20130311115144.GG31619@redhat.com> <513DDCC2.9070807@redhat.com> <20130311135441.GN31619@redhat.com> <513DE3C4.5000503@siemens.com> <20130311140503.GO31619@redhat.com> <513DE4DA.4050009@siemens.com> <20130311140925.GP31619@redhat.com> <513DE5E5.1080402@siemens.com> <20130311141252.GQ31619@redhat.com>
In-Reply-To: <20130311141252.GQ31619@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-11 15:12, Gleb Natapov wrote:
> On Mon, Mar 11, 2013 at 03:10:45PM +0100, Jan Kiszka wrote:
>> On 2013-03-11 15:09, Gleb Natapov wrote:
>>> On Mon, Mar 11, 2013 at 03:06:18PM +0100, Jan Kiszka wrote:
>>>> On 2013-03-11 15:05, Gleb Natapov wrote:
>>>>> On Mon, Mar 11, 2013 at 03:01:40PM +0100, Jan Kiszka wrote:
>>>>>>> We are not moving away from mp_state, we are moving away from using
>>>>>>> mp_state for signaling because with nested virt INIT does not always
>>>>>>> change mp_state, not only that it can change mp_state long after signal
>>>>>>> is received after vmx off is done.
>>>>>>
>>>>>> Right.
>>>>>>
>>>>>> BTW, for that to happen, we will also need to influence the INIT level.
>>>>>> Unless I misread the spec, INIT is blocked while in root mode, and if
>>>>>> you deassert INIT before leaving root (vmxoff, vmenter), nothing
>>>>>> actually happens. So what matters is the INIT signal level at the exit
>>>>>> of root mode.
>>>>>>
>>>>> You are talking about INIT# signal received via CPU pin, right? I think
>>>>> INIT send by IPI cannot go away.
>>>>
>>>> Why shouldn't it? Besides edge, there is also level-triggered INIT.
>>>>
>>> OK, so level-triggered INIT can be de-asserted what about edge triggered
>>> one? :)
>>
>> It should be lost while in root mode.
>>
> Ah, that's great. Removes some potential complications.

Again, that's my interpretation. I didn't check this against real HW
yet. It just makes most sense, given what I read.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
