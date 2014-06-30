Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbaF3TYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:24:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51181 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbaF3TYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:24:02 -0400
Date: Mon, 30 Jun 2014 21:23:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nick Warne <nick@linicks.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.15.2 build error on AMD64
Message-ID: <20140630192357.GI4766@pd.tnic>
References: <53AE9863.6050102@linicks.net>
 <53AE9F0B.1080207@linicks.net>
 <20140628122322.GC4373@pd.tnic>
 <53AEBE75.9070301@linicks.net>
 <53B063BC.4040200@linicks.net>
 <20140629194403.GB12943@pd.tnic>
 <53B07F99.40600@linicks.net>
 <20140629212423.GE12943@pd.tnic>
 <20140630132637.GD4766@pd.tnic>
 <53B1B194.3060907@linicks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53B1B194.3060907@linicks.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 07:51:00PM +0100, Nick Warne wrote:
> Ummm, interesting.
> 
> But is it solved?
> 
> Suppose developer a.n.other submits a patch that works with his/her GCC
> version but doesn't with some other GCC version.  I guess this will be
> picked up in GIT build tests, but that only then tells everybody to upgrade
> GCC or find a patch that fixes the issue (like you did, but I couldn't find
> it).

Well, this is generally something that will have to get fixed when
someone reports it. That's why I wanted to have an ancient environment
to build kernels in - just for that purpose. We have a bunch of people
who do test latest kernels on ancient hw and sw but as it is always the
case with testing, we cannot have total coverage.

So yes, in such cases, we aim at having the kernel build with all
supported gcc versions. Which brings me to your question below...

> Is there a document or something that stipulates what is the minimum
> version[s] of GCC to build a particular version of the kernel? If not,
> perhaps this is something that needs addressing.

#if GCC_VERSION < 30200
# error Sorry, your compiler is too old - please upgrade it.
#endif

... yes, so we do support gcc versions >= 3.2 and the kernel has to be
buildable with those.

So, long story short, people should report such issues to lkml so that
they get addressed.

Ok?

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
