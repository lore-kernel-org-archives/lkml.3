Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474Ab3BNB6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:58:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47492 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab3BNB6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:58:02 -0500
Message-ID: <511C444F.1040707@zytor.com>
Date: Wed, 13 Feb 2013 17:56:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, rostedt@goodmiss.org,
        aquini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org> <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com> <CA+55aFwZ2wN=9qTNNmqjPfK=ZwS=kx6HAAFj_cWLnJDbK1M0_Q@mail.gmail.com> <511C35CB.2010103@zytor.com> <CA+55aFz6qr_9sjG0Z3Cku3ahHX5zYOMiroryh2rL-HLJ=w0=_g@mail.gmail.com>
In-Reply-To: <CA+55aFz6qr_9sjG0Z3Cku3ahHX5zYOMiroryh2rL-HLJ=w0=_g@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 05:31 PM, Linus Torvalds wrote:
> On Wed, Feb 13, 2013 at 4:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> It does for the callee, but only on a whole-file basis.  It would be a
>> lot nicer if we could do it with function attributes.
> 
> A way to just set the callee-clobbered list on a per-function basis
> would be lovely. Gcc has limited support for this on some
> architectures, where you can specify "save every register for this
> function" in order to do things like interrupt handlers etc without
> even resorting to asm. But there is no generic (or even just x86)
> support for anything like it :-(
> 
> There are other calling-convention attributes that make me suspect gcc
> could easily do this (it already supports per-function ABI
> specification, so presumably it already has some concept of
> callee-saved registers being different for different attributes), but
> from my reading you currently have to generate asm wrappers by hand
> (and call them by hand with inline asm) if you want to do something
> like this.
> 

I just filed a gcc bugzilla on this:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=56314

	-hpa

