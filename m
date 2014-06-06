Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaFFL7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:59:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41749 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaFFL7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:59:02 -0400
Date: Fri, 6 Jun 2014 13:59:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/2] Add in-kernel /dev/random equivalent
Message-ID: <20140606115900.GA4367@amd.pavel.ucw.cz>
References: <1937020.H2HvEFgXrB@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1937020.H2HvEFgXrB@myon.chronox.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-05-12 00:36:01, Stephan Mueller wrote:
> Hi,
> 
> as discussed in thread [1], an in-kernel equivalent to the blocking 
> /dev/random device behavior is suggested. This in-kernel blocking access to 
> the RNG can be used to seed deterministic random number generators with random 
> numbers that are directly backed by the underlying noise sources.
> 
> The following patch implements this concept by adding a third output pool, the 
> kernel_pool that is only accessible inside the kernel. That kernel_pool feeds 
> the blocking operation API calls to obtain random numbers.
> 
> Please find a test kernel module attached. You can unload it even while the 
> collection process is ongoing.
> 
> [1] https://lkml.org/lkml/2014/4/27/174
> 
> Stephan Mueller (2):
>   Addition of kernel_pool
>   Asynchronous and syncronous API for accessing kernel_pool
> 
>  drivers/char/random.c  | 163 
> +++++++++++++++++++++++++++++++++++++++++++++----
>  include/linux/random.h |  16 +++++
>  2 files changed, 166 insertions(+), 13 deletions(-)

 * Copyright (c) 2014
 *
 * Permission is hereby granted, free of charge, to any person
 *obtaining a copy
 * of this software and associated documentation files (the
 *"Software"), to deal
 * in the Software without restriction, including without limitation
 *the rights
 * to use, copy, modify, merge, publish, distribute, sublicense,
 *and/or sell
 * copies of the Software, and to permit persons to whom the Software
 *is
 * furnished to do so, subject to the following conditions:

...but module_license says this is GPL...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
