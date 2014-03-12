Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaCLL1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:27:17 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:55168 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaCLL1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:27:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140311163123.GC25564@dhcp-26-207.brq.redhat.com>
References: <cover.1391688720.git.agordeev@redhat.com>
	<dd1eb6b2f0f88e90417ba6ad57393147816a4287.1391688720.git.agordeev@redhat.com>
	<20140226230554.GE11655@kmo>
	<CACVXFVPNE=ecVqt9-SnuFG8yWQJuXVYKzuNNNKaDJyq6t6wucw@mail.gmail.com>
	<20140311140322.GA24065@dhcp-26-207.brq.redhat.com>
	<CACVXFVMB4YyyEDph5CsVPRLFe4ZncxVrarxV7-VT2wC=pbPTZQ@mail.gmail.com>
	<20140311163123.GC25564@dhcp-26-207.brq.redhat.com>
Date: Wed, 12 Mar 2014 19:27:14 +0800
Message-ID: <CACVXFVM24tARya-yVfH1gB35jKFPP1nNnYf7EAirr0=wsWjs1Q@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] percpu_ida: Fix data race on cpus_have_tags cpumask
From: Ming Lei <tom.leiming@gmail.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 12:31 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Tue, Mar 11, 2014 at 11:34:21PM +0800, Ming Lei wrote:
>> I mean the below block can be put inside the previous lock:
>
> Oh, *now* I see what you mean. Please, ignore my prevous reply.
> Still, we want to release the lock as soon as possible and
> there is no reason to the below bits it under lock.

Actually my comment was wrong because pool->cpus_have_tags
should be guarded by pool->lock instead of the percpu tag->lock.

Sorry for the noise.

Thanks,
-- 
Ming Lei
