Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3FXX2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:28:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:52373 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3FXX2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:28:34 -0400
Date: Tue, 25 Jun 2013 01:28:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/itimer.c: beautify code, not need check 'value',
 so save one instruction, simpler and easier for readers.t
In-Reply-To: <51C3B4B4.90603@asianux.com>
Message-ID: <alpine.DEB.2.02.1306242242480.4013@ionos.tec.linutronix.de>
References: <51C2E6F9.80107@asianux.com> <alpine.DEB.2.02.1306201458100.4013@ionos.tec.linutronix.de> <51C3B4B4.90603@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jun 2013, Chen Gang wrote:
> >> > Also can let code simpler and easier for readers: if checking parameter
> >> > 'value', it will easily lead readers to think about why not return
> >> > -EINVAL instead of -EFAULT, when checking parameter failed.
> > So you are seriously claiming, that the check for !value makes people
> > think that the return value should be -EINVAL?
> > 
> > That's hillarious.
> > 
> That seems not a quite polite word, is it ?  ;-)

My apologies for being so impolite. Let me rephrase it. Here is a
"sample" changelog for your patch:

  Subject: itimers: Remove bogus NULL pointer check in sys_getitimer()

    People might be tricked into assuming that the return value for a
    failed NULL pointer check should be -EINVAL instead of -EFAULT.

    Remove the misleading NULL pointer check to fix this nuisance.

    Aside of that this patch fixes the problem of NOMMU kernels, where
    a NULL pointer dereference is a valid operation. This allows to
    boot NOMMU kernels without working around the shortcomings of the
    getitimer() system call, which have been ignored since this NULL
    pointer check was introduced in Linux 0.96a.


Please resubmit.

Thanks,

	tglx
