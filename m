Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3BFUKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:10:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab3BFUKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:10:42 -0500
Message-ID: <5112B8A2.8050800@redhat.com>
Date: Wed, 06 Feb 2013 15:10:10 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: Re: [PATCH -v4 4/5] x86,smp: keep spinlock delay values per hashed
 spinlock address
References: <20130125140553.060b8ced@annuminas.surriel.com> <20130125141842.58010c25@annuminas.surriel.com> <CANN689EAykWXS4QTVDKaCb4in_2b_Bqyoh-xg=EbX7ivOPry4w@mail.gmail.com>
In-Reply-To: <CANN689EAykWXS4QTVDKaCb4in_2b_Bqyoh-xg=EbX7ivOPry4w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2013 08:04 AM, Michel Lespinasse wrote:
> On Fri, Jan 25, 2013 at 11:18 AM, Rik van Riel <riel@redhat.com> wrote:
>> +       u32 delay = (ent->hash == hash) ? ent->delay : MIN_SPINLOCK_DELAY;
>
> I still don't like the reseting of delay to MIN_SPINLOCK_DELAY when
> there is a hash collision.

I've been spending some time looking at this, because I am
not a fan either.

However, it seems to work and I failed to come up with
anything better. Therefore, I have left it as is in the
-v5 patch series.
