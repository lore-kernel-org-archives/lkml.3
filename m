Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3FTG7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:59:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:59033 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3FTG7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:59:33 -0400
Date: Thu, 20 Jun 2013 08:59:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/itimer.c: for return value, using -EINVAL instead
 of -EFAULT
In-Reply-To: <51C29FBC.1090507@asianux.com>
Message-ID: <alpine.DEB.2.02.1306200847300.4013@ionos.tec.linutronix.de>
References: <51C29FBC.1090507@asianux.com>
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

> For the system call getitimer(), if the parameter 'value' is NULL, need
> return -EINVAL, not -EFAULT.

Care to explain why? Because you are feeling so?

I recommend reading the man page of getitimer:

 ERRORS
       EFAULT new_value, old_value, or curr_value is not valid a pointer.

And NULL is definitely NOT a valid pointer.

The Posix spec does not specify an explicit error value for this
syscall, but the general policy is:

[EFAULT]
    Bad address. The system detected an invalid address in attempting
    to use an argument of a call. The reliable detection of this error
    cannot be guaranteed, and when not detected may result in the
    generation of a signal, indicating an address violation, which is
    sent to the process.

And we made use of this, which is correct and makes sense.

Returning EINVAL makes no sense at all, because EINVAL _IS_ a
specified error code for this syscall:

[EINVAL]
        The which argument is not recognized.

Thanks,

	tglx
