Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3BDCSA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 21:18:00 -0500
Received: from ozlabs.org ([203.10.76.45]:55462 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab3BDCR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 21:17:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephan Mueller <stephan.mueller@atsec.com>
Cc: Kyle McMartin <kyle@redhat.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, jstancek@redhat.com
Subject: Re: [PATCH] MODSIGN: flag modules that use cryptoapi and only panic if those are unsigned
In-Reply-To: <51027D9D.6030507@atsec.com>
References: <20130122184357.GD6538@redacted.bos.redhat.com> <8615.1358940375@warthog.procyon.org.uk> <50FFFF48.6020608@atsec.com> <20130124190610.GI6538@redacted.bos.redhat.com> <874ni6qhlq.fsf@rustcorp.com.au> <51027D9D.6030507@atsec.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 04 Feb 2013 10:04:58 +1030
Message-ID: <87y5f5km3h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller <stephan.mueller@atsec.com> writes:
> On 25.01.2013 00:36:01, +0100, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> "the module signature" here being the signature of any crypto module,
>> I'm guessing from Kyle's awful patch.  Any crypto module, or just some?
>> Presumably any module used by any crypto module, too?
>
> Any module loading into the kernel crypto API must be caught and its
> signature enforced. Thus Kyle's approach to catch the kernel crypto API
> register function would be appropriate, if indeed we would catch all
> crypto KOs that we want to catch -- see my remark to Kyle.

OK, so perhaps in fips mode we should fail the various crypto register
calls if the kernel is tainted?

> But that is not the focus of the FIPS test here. That test shall counter
> accidental modifications (how unlikely they are). And I am fully aware
> of the fact that this FIPS requirement does not make too much sense in
> software implementations. Note, FIPS 140-2 mainly focuses on hardware
> and has some requirements which are totally bogus for software -- this
> is one of them.
>
> Well, but if we want to be FIPS 140-2 compliant, either we meet that
> requirement, or, well, you are not compliant. It is that easy. :-)

Two important principles here:
1) Ugliness and craziness must be contained in the subsystem which cares.
2) Minimize effort spent on craziness.

Principle #1 means I want this in the crypto subsystem, not the module
subsystem.

Cheers,
Rusty.
