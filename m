Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaKLRVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:21:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaKLRVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:21:34 -0500
Date: Wed, 12 Nov 2014 18:20:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>,
        tony.luck@intel.com, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 4/5] x86/mce: Simplify flow when handling
	recoverable memory errors
Message-ID: <20141112172057.GA8303@redhat.com>
References: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com> <1407998986-1834-5-git-send-email-gong.chen@linux.intel.com> <20141111114248.GD31490@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111114248.GD31490@pd.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I am a bit confused...

On 11/11, Borislav Petkov wrote:
>
> Roughly speaking, we want to be able to mark a task with the sign of
> death and to kill it, if needed.

"it" is current, yes?

So I agree with Andy, task_work_add() can work and you can also pass
paddr/restartable to the handler.

But,

> The important part is *before* it
> gets to run again.

But it is already running? Perhaps you meant "before it returns to
user-mode" ?

Oleg.

