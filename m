Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbaKAAD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 20:03:27 -0400
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:59968 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753431AbaKAAD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 20:03:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:4321:5007:6261:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bed98_1d97088434e11
X-Filterd-Recvd-Size: 2000
Message-ID: <1414800201.13647.9.camel@perches.com>
Subject: Re: [PATCH v2] x86, boot: add hex output for debugging
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Junjie Mao <eternal.n08@gmail.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Fri, 31 Oct 2014 17:03:21 -0700
In-Reply-To: <20141031234531.GA12082@thin>
References: <20141031205819.GA13262@www.outflux.net>
	 <CAE9FiQVYBwTifYXACeJRBOEtrN6o5kBpA6v0xLqUYS379pH-Mw@mail.gmail.com>
	 <20141031234531.GA12082@thin>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 16:45 -0700, Josh Triplett wrote:
> I don't think we need the full generality of printf in the decompression
> stub.  I prefer Kees' patch, though I'd still like to see __puthex made
> conditional.

Maybe use a statement expression macro instead?
Something like this could emit the right number of bits for any type

#define __puthex(val)							\
({									\
	typeof(val) value = val;					\
	char alpha[2] = {};						\
	int bits;							\
									\
	__putstr("0x");							\
	for (bits = sizeof(value) * 8 - 4; bits >= 0; bits -= 4) {	\
		int digit = (value >> bits) & 0xf;			\
									\
		if (digit < 10)						\
			alpha[0] = '0' + digit;				\
		else							\
			alpha[0] = 'a' + (digit - 10);			\
									\
		__putstr(alpha);					\
	}								\
})


