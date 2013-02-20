Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935355Ab3BTMbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:31:47 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64980 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935130Ab3BTMbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:31:45 -0500
MIME-Version: 1.0
In-Reply-To: <20130219142836.GA13196@gmail.com>
References: <20130219142836.GA13196@gmail.com>
Date: Wed, 20 Feb 2013 20:31:44 +0800
Message-ID: <CAJd=RBAQ3GHXNFT_EoxjuY=gRVMqc2=+=6PR1ujZOCq-KsU_pQ@mail.gmail.com>
Subject: Re: [GIT PULL] smp/hotplug changes for v3.9
From: Hillf Danton <dhillf@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 10:28 PM, Ingo Molnar <mingo@kernel.org> wrote:
> +       /* drain remaining works */
> +       spin_lock_irqsave(&stopper->lock, flags);
> +       list_for_each_entry(work, &stopper->works, list)
> +               cpu_stop_signal_done(work->done, false);

After flushing enqueued works, in what state is the works list head, Thomas?

> +       stopper->enabled = false;
> +       spin_unlock_irqrestore(&stopper->lock, flags);
>  }
