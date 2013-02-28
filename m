Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3B1CyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 21:54:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab3B1Cx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 21:53:59 -0500
Message-ID: <512EC7F0.60103@redhat.com>
Date: Wed, 27 Feb 2013 21:58:56 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org> <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com> <511BE4A3.8050607@redhat.com> <CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com> <511C1204.9040608@redhat.com> <CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com> <511C24A6.8020409@redhat.com> <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com> <512E376D.70105@redhat.com> <CA+55aFzPxJ3rfZvAvrP9LxCXfDU8AAVvhMZnP-OAoe-ycc70aw@mail.gmail.com> <512E6443.9050603@redhat.com> <CA+55aFwHxv9RH75BoXYcwdKeHx+otOOpg9494TTdFwQe3biOhw@mail.gmail.com> <512E80E3.7060800@redhat.com> <CA+55aFwa0EjGG2NUDYVLVBmXJa2k81YiuNO2yggk=GLRQxhhUQ@mail.gmail.com>
In-Reply-To: <CA+55aFwa0EjGG2NUDYVLVBmXJa2k81YiuNO2yggk=GLRQxhhUQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 05:13 PM, Linus Torvalds wrote:
>
> On Feb 27, 2013 1:56 PM, "Rik van Riel" <riel@redhat.com
> <mailto:riel@redhat.com>> wrote:
>>
>> No argument there, but that does in no way negate the need for some
>> performance robustness.
>
> The very numbers you posted showed that the backoff was *not* more
> robust. Quite the reverse, there was arguably more variability.

On the other hand, both MCS and the fast queue locks
implemented by Michel showed low variability and high
performance.

http://thread.gmane.org/gmane.linux.kernel/1427417

> So I really don't like how you make these sweeping statements
> *again*. Numbers talk, bullshit walks.

If you read all the text in my last mail, you will see the
link to Michel's performance results. The numbers speak for
themselves.

> The fact is, life is complicated. The simple spinlocks tend to work
> really well. People have tried fancy things before, and it turns out
> it's not as simple as they think.

The numbers for both the simple spinlocks and the
spinlock backoff kind of suck. Both of these have
high variability, and both eventually fall down
under heavy load.

The numbers for Michel's MCS and fast queue lock
implementations appear to be both fast and stable.

I agree that we need numbers.

I do not agree that other locks should be dismissed
out of hand without looking at the numbers.

