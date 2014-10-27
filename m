Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaJ0VS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:18:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:40692 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaJ0VS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:18:28 -0400
Date: Mon, 27 Oct 2014 22:18:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Paris <eparis@redhat.com>
cc: Richard Guy Briggs <rgb@redhat.com>, linux-kernel@vger.kernel.org,
        przanoni@gmail.com, mingo@kernel.org, hpa@linux.intel.com,
        hpa@zytor.com, linux-tip-commits@vger.kernel.org,
        linux-audit@redhat.com
Subject: Re: [PATCH] i386/audit: stop scribbling on the stack frame
In-Reply-To: <1414418157.24347.1.camel@redhat.com>
Message-ID: <alpine.DEB.2.11.1410272212420.5308@nanos>
References: <1414037043-30647-1-git-send-email-eparis@redhat.com>  <tip-26c2d2b39128adba276d140eefa2745591b88536@git.kernel.org>  <alpine.DEB.2.11.1410251034320.5308@nanos>  <20141027023457.GY15532@madcap2.tricolour.ca>
 <1414418157.24347.1.camel@redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Eric Paris wrote:

> My patch was already committed to the -tip urgent branch.  I believe any
> optimization should be based on that branch, Richard.  If you are trying
> to wrangle every bit of speed out of this, should you
> 
> push %esi;
> push %edi;
> CFI_ADJUST_CFA_OFFSET 8

Wrong. You want to use pushl_cfi as you need the CFI adjustment after
each modification of esp.

> call __audit_syscall_entry
> pop;
> pop;
> CFI_ADJUST_CFA_OFFSET -8
> 
> Instead of using the pushl_cfi and popl_cfi macros?

Wrong again. See above. Aside of that, why do you want to use pop at
all? All we care about is adjusting esp, right?

Thanks,

	tglx
