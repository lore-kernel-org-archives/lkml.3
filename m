Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaBZCi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:38:58 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47754 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaBZCi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:38:56 -0500
Message-ID: <530D53BB.2020702@converseincode.com>
Date: Tue, 25 Feb 2014 18:38:51 -0800
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, mmarek@suse.cz, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, sparse@chrisli.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        =?ISO-8859-1?Q?Jan-Simon_M=F6?= =?ISO-8859-1?Q?ller?= 
	<dl9pf@gmx.de>,
        Mark Charlebois <mcharleb@gmail.com>
Subject: Re: [PATCH 2/5] kbuild: LLVMLinux: Adapt warnings for compilation
 with clang
References: <1393376923-21892-1-git-send-email-behanw@converseincode.com> <1393376923-21892-3-git-send-email-behanw@converseincode.com> <20140226011737.GA4564@redhat.com>
In-Reply-To: <20140226011737.GA4564@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/14 17:17, Dave Jones wrote:
> On Tue, Feb 25, 2014 at 05:08:40PM -0800, behanw@converseincode.com wrote:
>   
>   > When compiling kernel with clang, disable warnings which are too noisy, and
>   > add the clang flag catch-undefined-behavior.
>   >
>   > +# Clang
>   > +warning-1 += $(call cc-disable-warning, initializer-overrides)
>   > +warning-1 += $(call cc-disable-warning, unused-value)
>   > +warning-1 += $(call cc-disable-warning, format)
>   > +warning-1 += $(call cc-disable-warning, unknown-warning-option)
>   > +warning-1 += $(call cc-disable-warning, self-assign)
>   > +warning-1 += $(call cc-disable-warning, sign-compare)
>   > +warning-1 += $(call cc-disable-warning, format-zero-length)
>   > +warning-1 += $(call cc-disable-warning, uninitialized)
>   > +warning-1 += $(call cc-option, -fcatch-undefined-behavior)
>
> Do you have a pointer to an example log-file from before this change ?
> I'm curious for eg, which self-assign warnings are showing up,
> because I've been fixing up the ones that Coverity found, of which
> there are only a dozen or so left iirc.
I count 22 in this particular x86 kernel build (some of which you may 
well have fixed already). Enjoy.

http://buildbot.llvm.linuxfoundation.org/self-assign-build.log.txt

Perhaps I should re-enable that warning, considering the number has 
dropped so dramatically from when I last checked over a year ago.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

