Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900Ab3BIXum (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 18:50:42 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:41781 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760887Ab3BIXul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 18:50:41 -0500
MIME-Version: 1.0
In-Reply-To: <5112B8A2.8050800@redhat.com>
References: <20130125140553.060b8ced@annuminas.surriel.com>
	<20130125141842.58010c25@annuminas.surriel.com>
	<CANN689EAykWXS4QTVDKaCb4in_2b_Bqyoh-xg=EbX7ivOPry4w@mail.gmail.com>
	<5112B8A2.8050800@redhat.com>
Date: Sat, 9 Feb 2013 15:50:37 -0800
Message-ID: <CANN689F=hsL0tkvhWUry9WxF3YwYV40JKiZ9ZoOQwEuLXz_iVA@mail.gmail.com>
Subject: Re: [PATCH -v4 4/5] x86,smp: keep spinlock delay values per hashed
 spinlock address
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 12:10 PM, Rik van Riel <riel@redhat.com> wrote:
> On 01/27/2013 08:04 AM, Michel Lespinasse wrote:
>>
>> On Fri, Jan 25, 2013 at 11:18 AM, Rik van Riel <riel@redhat.com> wrote:
>>>
>>> +       u32 delay = (ent->hash == hash) ? ent->delay :
>>> MIN_SPINLOCK_DELAY;
>>
>> I still don't like the reseting of delay to MIN_SPINLOCK_DELAY when
>> there is a hash collision.
>
> I've been spending some time looking at this, because I am
> not a fan either.
>
> However, it seems to work and I failed to come up with
> anything better. Therefore, I have left it as is in the
> -v5 patch series.

Does that mean you know of workloads that would regress if you didn't
reset the delay to MIN_SPINLOCK_DELAY when detecting a hash collision
?

I have not seen any public reports of that...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
