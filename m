Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaCKQ3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:29:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbaCKQ3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:29:53 -0400
Date: Tue, 11 Mar 2014 17:31:24 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Kent Overstreet <kmo@daterainc.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 1/3] percpu_ida: Fix data race on cpus_have_tags
 cpumask
Message-ID: <20140311163123.GC25564@dhcp-26-207.brq.redhat.com>
References: <cover.1391688720.git.agordeev@redhat.com>
 <dd1eb6b2f0f88e90417ba6ad57393147816a4287.1391688720.git.agordeev@redhat.com>
 <20140226230554.GE11655@kmo>
 <CACVXFVPNE=ecVqt9-SnuFG8yWQJuXVYKzuNNNKaDJyq6t6wucw@mail.gmail.com>
 <20140311140322.GA24065@dhcp-26-207.brq.redhat.com>
 <CACVXFVMB4YyyEDph5CsVPRLFe4ZncxVrarxV7-VT2wC=pbPTZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMB4YyyEDph5CsVPRLFe4ZncxVrarxV7-VT2wC=pbPTZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 11:34:21PM +0800, Ming Lei wrote:
> I mean the below block can be put inside the previous lock:

Oh, *now* I see what you mean. Please, ignore my prevous reply.
Still, we want to release the lock as soon as possible and
there is no reason to the below bits it under lock.

>          if (nr_free == 1)
>              cpumask_set_cpu()
> 
> As I mentioned, 'nr_free == 1' doesn't happen frequently, so
> it won't be big deal, will it?

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
