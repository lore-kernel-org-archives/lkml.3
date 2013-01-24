Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3AYDER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:04:17 -0500
Received: from ozlabs.org ([203.10.76.45]:48255 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab3AYDDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:03:24 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kyle McMartin <kyle@redhat.com>, linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, jstancek@redhat.com,
        Stephan Mueller <stephan.mueller@atsec.com>
Subject: Re: [PATCH] MODSIGN: flag modules that use cryptoapi and only panic if those are unsigned
In-Reply-To: <20130124190610.GI6538@redacted.bos.redhat.com>
References: <20130122184357.GD6538@redacted.bos.redhat.com> <8615.1358940375@warthog.procyon.org.uk> <50FFFF48.6020608@atsec.com> <20130124190610.GI6538@redacted.bos.redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 25 Jan 2013 10:06:01 +1030
Message-ID: <874ni6qhlq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin <kyle@redhat.com> writes:
> After thinking about it a while, this seems like the best way to solve
> the problem, although it does still kind of offend my delicate
> sensibilities...

You're far too polite.  This patch was horrible, partial and ugly.

Stephan Mueller <stephan.mueller@atsec.com> wrote:
> FIPS requires the module (in our case the static kernel binary with its
> kernel crypto API plus all the crypto kernel modules) to be unavailable
> if the module signature fails. That is an unconditional requirement.

"the module signature" here being the signature of any crypto module,
I'm guessing from Kyle's awful patch.  Any crypto module, or just some?
Presumably any module used by any crypto module, too?

Because you can panic when a !sig_ok module registers a crypto
algorithm.  Or you can panic when anyone registers a crypto algorithm
after any module has failed the signature check.

But it doesn't make much sense to pick on the crypto modules, since
they're not well isolated from the rest of the kernel.

Thanks,
Rusty.
