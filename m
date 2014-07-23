Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaGWMKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:10:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45707 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293AbaGWMKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:10:18 -0400
Message-Id: <1406117416.4473.144770005.5B5ED8C2@webmail.messagingengine.com>
X-Sasl-Enc: mcHVCwtl6Wh79DrBkNpeOhjQEBokFhmj0tKMSkWulqgn 1406117416
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: George Spelvin <linux@horizon.com>, tytso@mit.edu
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-c420910d
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Wed, 23 Jul 2014 14:10:16 +0200
In-Reply-To: <20140723115253.9808.qmail@ns.horizon.com>
References: <20140723115253.9808.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, Jul 23, 2014, at 13:52, George Spelvin wrote:
> I keep wishing for a more general solution.  For example, some way to
> have a "spare" extra fd that could be accessed with a special O_NOFAIL
> flag.
> 
> That would allow any number of library functions to not fail, such as
> logging from nasty corner cases.
> 
> But you'd have to provide one per thread, and block non-fatal signals
> while it was open, so you don't get reentrancy problems.  Ick.
> 
> 
> This overly-specialized system call (and worse yet, a blocking
> system call that you can't put into a poll() loop) just feels ugly
> to me.  Is it *absolutely* necessary?

One point that often came up besides fd exhaustion is missing
/dev/u?random device nodes in chroot environments.

I also thought about a more general interface, like e.g. an
opennod(dev_t device, int flags) call but all those ideas ended up being
very complex changes besides having design issues. getrandom is simple
and solves a real problem.

The only problem I see, that we allow access to /dev/random without
checking any permission bits like we did on opening /dev/random before
and we cannot restrict applications to deplete the whole entropy pool.

> For example, how about simply making getentropy() a library function that
> aborts if it can't open /dev/urandom?  If you're suffering fd exhaustion,
> you're being DoSed already.

Maybe applications want to mitigate fd exhaustion.

Bye,
Hannes
