Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaA2QHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:07:25 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:42150 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaA2QHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:07:24 -0500
MIME-Version: 1.0
In-Reply-To: <20140129145535.GA12562@redhat.com>
References: <1390895840.8373.2.camel@beeld>
	<20140128164320.GB7596@redhat.com>
	<CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com>
	<20140129145535.GA12562@redhat.com>
Date: Wed, 29 Jan 2014 22:07:22 +0600
Message-ID: <CADZ9YHjEfEWJx5z_5KZnfQAVHXY3u613XV7vdZqjts4zFR3_=g@mail.gmail.com>
Subject: Re: Do we really need curr_target in signal_struct ?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 8:55 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/29, Rakib Mullick wrote:
>>
>> On Tue, Jan 28, 2014 at 10:43 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>>
>
>> AFAIU, ->current_target is only a loop breaker to avoid infinite loop,
>
> No. It caches the last result of "find a thread which can handle this
> group-wide signal".
>
The reason behind of my understanding is the following comments:

                                /*
                                 * No thread needs to be woken.
                                 * Any eligible threads will see
                                 * the signal in the queue soon.
                                 */

What if, there's no thread in a group wants_signal()? Or it can't
practically happen?

>> but - by using while_each_thread() we can remove it completely, thus
>> helps to get rid from maintaining it too.
>
> ... and remove the optimization above.
>
>> I'll prepare a proper patch with you suggestions for reviewing.
>
> I am not sure we want this patch. Once again, I do not know how much
> ->curr_target helps, and certainaly it can't help always. But you
> should not blindly remove it just because yes, sure, it is not strictly
> needed to find a wants_signal() thread.
>
Are you thinking that , since things are not broken, then we shouldn't
try to do anything?

Thanks,
Rakib
