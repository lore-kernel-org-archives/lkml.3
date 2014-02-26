Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaBZBSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:18:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbaBZBSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:18:33 -0500
Date: Tue, 25 Feb 2014 20:17:37 -0500
From: Dave Jones <davej@redhat.com>
To: behanw@converseincode.com
Cc: mmarek@suse.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, sparse@chrisli.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
        torvalds@linux-foundation.org, dwmw2@infradead.org,
        pageexec@freemail.hu,
        Jan-Simon =?iso-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>,
        Mark Charlebois <mcharleb@gmail.com>
Subject: Re: [PATCH 2/5] kbuild: LLVMLinux: Adapt warnings for compilation
 with clang
Message-ID: <20140226011737.GA4564@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, behanw@converseincode.com,
	mmarek@suse.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	x86@kernel.org, sparse@chrisli.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
	torvalds@linux-foundation.org, dwmw2@infradead.org,
	pageexec@freemail.hu,
	Jan-Simon =?iso-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>,
	Mark Charlebois <mcharleb@gmail.com>
References: <1393376923-21892-1-git-send-email-behanw@converseincode.com>
 <1393376923-21892-3-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393376923-21892-3-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 05:08:40PM -0800, behanw@converseincode.com wrote:
 
 > When compiling kernel with clang, disable warnings which are too noisy, and
 > add the clang flag catch-undefined-behavior.
 >  
 > +# Clang
 > +warning-1 += $(call cc-disable-warning, initializer-overrides)
 > +warning-1 += $(call cc-disable-warning, unused-value)
 > +warning-1 += $(call cc-disable-warning, format)
 > +warning-1 += $(call cc-disable-warning, unknown-warning-option)
 > +warning-1 += $(call cc-disable-warning, self-assign)
 > +warning-1 += $(call cc-disable-warning, sign-compare)
 > +warning-1 += $(call cc-disable-warning, format-zero-length)
 > +warning-1 += $(call cc-disable-warning, uninitialized)
 > +warning-1 += $(call cc-option, -fcatch-undefined-behavior)

Do you have a pointer to an example log-file from before this change ?
I'm curious for eg, which self-assign warnings are showing up,
because I've been fixing up the ones that Coverity found, of which
there are only a dozen or so left iirc.

Some of the others may also be interesting.

	Dave

