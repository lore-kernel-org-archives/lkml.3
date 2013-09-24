Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab3IXQoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:44:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab3IXQog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:44:36 -0400
Date: Tue, 24 Sep 2013 18:38:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, security@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] kthread: Make kthread_create() killable.
Message-ID: <20130924163811.GA4036@redhat.com>
References: <20130914160515.GA8627@redhat.com> <201309150846.HED51521.tJOFOMVFSOHQFL@I-love.SAKURA.ne.jp> <20130915163919.GC13344@redhat.com> <201309160953.IGI12418.FOQHOFVJLOMFSt@I-love.SAKURA.ne.jp> <20130923160725.49093c565dcf6df7037dcc6b@linux-foundation.org> <201309250017.HBG57846.VFOStOFFOLQJHM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309250017.HBG57846.VFOStOFFOLQJHM@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25, Tetsuo Handa wrote:
>
> Subject: [PATCH] kthread: make kthread_create() killable

The patch looks correct... although I'll try to reread it later ;)

Minor nit, since you are sending the new version anyway...

> +	if (unlikely(wait_for_completion_killable(&done))) {
> +		/*
> +		 * If I was SIGKILLed before kthreadd (or new kernel thread)
> +		 * calls complete(), leave the cleanup of this structure to
> +		 * that thread.
> +		 */
> +		if (xchg(&create->done, NULL))
> +			return ERR_PTR(-ENOMEM);

ENOMEM? Perhaps EINTR makes more sense.

Oleg.

