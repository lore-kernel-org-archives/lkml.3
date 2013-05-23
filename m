Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab3EWOhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:37:12 -0400
Received: from smtp-out-100.synserver.de ([212.40.185.100]:1034 "EHLO
	smtp-out-100.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab3EWOhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:37:11 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10224
Message-ID: <519E2985.8000704@metafoo.de>
Date: Thu, 23 May 2013 16:36:53 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regmap: Make regmap-mmio usable from different contexts
References: <1369314377-22873-1-git-send-email-lars@metafoo.de> <1369314377-22873-2-git-send-email-lars@metafoo.de> <20130523140503.GD2412@sirena.org.uk> <519E25AB.4060406@metafoo.de> <20130523143137.GH2412@sirena.org.uk>
In-Reply-To: <20130523143137.GH2412@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 04:31 PM, Mark Brown wrote:
> On Thu, May 23, 2013 at 04:20:27PM +0200, Lars-Peter Clausen wrote:
>> On 05/23/2013 04:05 PM, Mark Brown wrote:
> 
>>> This seems really invasive, why not just have the lock that gets passed
>>> in point to a struct which has both the lock and the flags?  As far as
>>> the core is concerned the lock is just whatever data is required to do
>>> the locking, the fact that it's actually two values is an implementation
>>> detail of this locking implementation.
> 
>> I think that won't work. spin_lock_irqsave() will write to the flags
>> parameter before it has successfully taken the look. So if a process running
>> on another CPU tries to acquire the the lock while it is already held we'll
>> end up overwriting the flags. E.g:
> 
> So you'd have to allocate a struct on the stack with a pointer and the
> flags in it and initialise the pointer.  Not awesome but not the end of
> the world.

I'm not sure I understand what you mean. This needs to be done for each
caller of a lock()/unlock() pair. We can't allocate the flags on the stack
inside the lock() function since the stack will be gone once the function exits.

- Lars
