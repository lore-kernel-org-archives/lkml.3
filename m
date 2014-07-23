Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbaGWLw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:52:57 -0400
Received: from ns.horizon.com ([71.41.210.147]:34359 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755263AbaGWLw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:52:56 -0400
Date: 23 Jul 2014 07:52:53 -0400
Message-ID: <20140723115253.9808.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hannes@stressinduktion.org, tytso@mit.edu
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@horizon.com
In-Reply-To: <1406108835.2603.144733749.2407B407@webmail.messagingengine.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I keep wishing for a more general solution.  For example, some way to
have a "spare" extra fd that could be accessed with a special O_NOFAIL
flag.

That would allow any number of library functions to not fail, such as
logging from nasty corner cases.

But you'd have to provide one per thread, and block non-fatal signals
while it was open, so you don't get reentrancy problems.  Ick.


This overly-specialized system call (and worse yet, a blocking
system call that you can't put into a poll() loop) just feels ugly
to me.  Is it *absolutely* necessary?

For example, how about simply making getentropy() a library function that
aborts if it can't open /dev/urandom?  If you're suffering fd exhaustion,
you're being DoSed already.
