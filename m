Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab3JHQyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:54:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab3JHQyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:54:07 -0400
Date: Tue, 8 Oct 2013 18:46:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131008164626.GA25696@redhat.com>
References: <20131005234430.GA22485@localhost> <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com> <20131008075151.GA15689@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008075151.GA15689@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08, Fengguang Wu wrote:
>
> Yeah, this will quiet the oops messages:
>
> -#ifdef CC_HAVE_ASM_GOTO
> +#if 0

Can't understand how this can affect task_work.c...

Well, task_work_add() does test_and_set_bit(), so that patch actually
changes this code, but still I can't see how this can lead to these
OOPSes.

Fengguang, I do not think this will help, but just in case. Could you
show the result of

	$ kernel/task_work.s

?

Oleg.

