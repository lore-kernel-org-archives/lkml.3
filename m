Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab3IDB1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:27:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab3IDB1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:27:23 -0400
Date: Tue, 3 Sep 2013 18:27:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@gentwo.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH-v5 1/6] idr: Percpu ida
Message-Id: <20130903182749.21052ab6.akpm@linux-foundation.org>
In-Reply-To: <1378224418.32763.409.camel@haakon3.risingtidesystems.com>
References: <1377917556-11955-1-git-send-email-nab@linux-iscsi.org>
	<1377917556-11955-2-git-send-email-nab@linux-iscsi.org>
	<1378224418.32763.409.camel@haakon3.risingtidesystems.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Sep 2013 09:06:58 -0700 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> Are there any other review comments to be addressed for this patch..?
> 
> If not, please kindly give your Reviewed-by if your OK for an initial
> standalone merge.

Sorry, I'm largely offline for the next week...

It looks OK to me (that's as close as I get to an ack :))

Nit:

> +		if (cpu >= nr_cpu_ids)
> +			cpu = cpumask_first(&pool->cpus_have_tags);
> +
> +		if (cpu >= nr_cpu_ids)
> +			BUG();

The second `if' can be moved inside the first, but hopefully the
compiler already did that.

I have dim memories that doing

	local_irq_save()
	spin_lock()

is not equivalent to

	spin_lock_irqsave()

in some circumstances.  Perhaps a lockdep thing.  Or perhaps this was fixed in
the intervening years and this is no longer the case.

Such things probably won't be detected during 3.12-rcX because few
people will test iscsi, I expect.  So please be sure that you've
runtime tested it with all the lockdeppy things enabled. 
Documentation/SubmitChecklist section 12 has a list, but it might be
dated.
