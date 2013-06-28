Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab3F1OM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:12:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42734 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802Ab3F1OM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:12:58 -0400
Message-ID: <51CD99C2.9040109@zytor.com>
Date: Fri, 28 Jun 2013 07:12:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
References: <1372416851-56830-1-git-send-email-wedsonaf@gmail.com> <20130628111948.GA31065@gmail.com> <20130628140938.GA24819@pd.tnic>
In-Reply-To: <20130628140938.GA24819@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 07:09 AM, Borislav Petkov wrote:
> 
> Our testing for asm goto otherwise is a bit more, hmm, hands-on in
> arch/x86/include/asm/cpufeature.h:
> 
> #if __GNUC__ > 4 || __GNUC_MINOR__ >= 5
> 
> Maybe I should change that to the more explicit CC_HAVE_ASM_GOTO then.
> 

We should... we didn't have the asm goto test at the time that code was
written, but I think the tracing guys added it either because some
distros backported asm goto or to deal with it on non-x86 architectures.

	-hpa

