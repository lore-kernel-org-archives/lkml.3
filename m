Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab3FTNmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:42:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:33228 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889Ab3FTNmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:42:07 -0400
Date: Thu, 20 Jun 2013 15:42:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/itimer.c: beautify code, not need check 'value',
 so save one instruction, simpler and easier for readers.
In-Reply-To: <51C2E6F9.80107@asianux.com>
Message-ID: <alpine.DEB.2.02.1306201458100.4013@ionos.tec.linutronix.de>
References: <51C2E6F9.80107@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Chen Gang wrote:

kernel/itimer.c: beautify code, not need check 'value', so 
          save one instruction, simpler and easier for readers.

That's an essay and not a proper subject line for a patch. 

See Documentation/SubmittingPatches and look at the other patch
subject lines in git log.

> Since copy_to_user() will check 'value', we do not need check it outside
> again,  so can save one comparing instruction at least.

copy_to_user() does not check value, it will fault due to a NULL
pointer dereference and execute the exception fixup. 

That's a massive difference which wants to be documented and argued
why it's ok to do so.

Aside of that, please line break the changelog lines around 78
characters.

> Also can let code simpler and easier for readers: if checking parameter
> 'value', it will easily lead readers to think about why not return
> -EINVAL instead of -EFAULT, when checking parameter failed.

So you are seriously claiming, that the check for !value makes people
think that the return value should be -EINVAL?

That's hillarious.

Can you please start to think about, why YOU thought that returning
-EINVAL is the proper return value for that case?

Simply because in your rush to submit patches according to your self
defined contribution plan, you fail to sit down and carefully study
the code and the according documentation (man page). Instead of that
you see some random snippet of code which looks wrong to you and you
send out patches without care. After someone points out your failure
you claim that the code is misleading to readers.

The code is not misleading to careful readers, it's only misleading to
sloppy readers.

And I'm neither accepting sloppy patches nor am I accepting sloppy
changelogs which make false claims.

Thanks,

	tglx
