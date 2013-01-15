Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab3AOSRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:17:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:38702 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab3AOSRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:17:32 -0500
Message-ID: <1358273835.2782.5.camel@pasglop>
Subject: Re: [PATCH] powerpc: added DSCR support to ptrace
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 Jan 2013 05:17:15 +1100
In-Reply-To: <1357885749-14042-1-git-send-email-aik@ozlabs.ru>
References: <1357885749-14042-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-11 at 17:29 +1100, Alexey Kardashevskiy wrote:
> +static unsigned long get_user_dscr(struct task_struct *task)
> +{
> +       return -EIO;
> +}
> +

Does it make sense to return an error here ? ptrace_get_reg() doesn't
seem to have provisions for returning errors, it just return register
values, there's no way to differenciate an error code from a register
value as far as I can tell...

I'll apply your patch anyway because this is an existing problem with
that function (it already returns -EIO in other circumstances), but I
would like if you could submit a followup patch that changes it to
return the register by value and return a real error code, which can be
then handled properly in the two call sites (ptrace.c and ptrace32.c).

Cheers,
Ben.


