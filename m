Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaJ0RCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:02:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45167 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbaJ0RC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:02:29 -0400
Message-ID: <544E7A8D.1030909@zytor.com>
Date: Mon, 27 Oct 2014 10:02:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        przanoni@gmail.com, mingo@kernel.org, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH] i386/audit: stop scribbling on the stack frame
References: <1414037043-30647-1-git-send-email-eparis@redhat.com>	 <tip-26c2d2b39128adba276d140eefa2745591b88536@git.kernel.org>	 <alpine.DEB.2.11.1410251034320.5308@nanos>	 <20141027023457.GY15532@madcap2.tricolour.ca> <1414418157.24347.1.camel@redhat.com>
In-Reply-To: <1414418157.24347.1.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 06:55 AM, Eric Paris wrote:
> My patch was already committed to the -tip urgent branch.  I believe any
> optimization should be based on that branch, Richard.  If you are trying
> to wrangle every bit of speed out of this, should you
> 
> push %esi;
> push %edi;
> CFI_ADJUST_CFA_OFFSET 8
> call __audit_syscall_entry
> pop;
> pop;
> CFI_ADJUST_CFA_OFFSET -8
> 
> Instead of using the pushl_cfi and popl_cfi macros?
> 
> I wrote my patch to be obviously correct, but agree there are certainly
> some speedups possible.
> 

Uh... not only is that plain wrong (the CFI should be adjusted after
each instruction that changes the stack pointer), but what the heck is
wrong with using the macros?

	-hpa



