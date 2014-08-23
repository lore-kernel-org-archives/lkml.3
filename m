Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbaIDUwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:52:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45666 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaIDUwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:52:40 -0400
Date: Sun, 24 Aug 2014 00:26:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: John Stultz <john.stultz@linaro.org>
Cc: ksummit-discuss@lists.linuxfoundation.org,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: (Resend) 2038 Kernel Summit Discussion Fodder
Message-ID: <20140823222640.GA1382@xo-6d-61-c0.localdomain>
References: <53EAAC95.7080301@linaro.org>
 <CALAqxLWvSn2_6dakGiQ4VEtYHH2Dt7BL0pn5XHgLWOV4ePqhBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLWvSn2_6dakGiQ4VEtYHH2Dt7BL0pn5XHgLWOV4ePqhBw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> There was also some pre-discussion before the sessions started around
> why we don't just change time_t to be unsigned. From the kernel's
> point of view this would be mostly fine, since dates before 1970 are
> not considered valid for any internal uses (with the exception of some
> filesystem timestamps). However, the problem with this approach is
> that userspace may want to handle dates prior to 1970, so this would
> eliminate that possibility. And removing the sign could cause problems
> with existing comparison logic. There is also the fact that having the
> same time unit range on 32bit and 64bit systems avoids complicating
> how timestamps are interpreted between architectures, where as having
> it be unsigned on 32bit but signed on 64bit would likely cause
> confusion. It is quite likely that using unsigned timestamps will be a
> useful solution for cases where timestamps cannot be converted to
> 64bits, but from the kernel perspective if we are going to change the
> abi, we should probably go all the way to 64bits. There seemed to be
> no disagreement here.
> 
> For the rest of the session, I opened it up for further thoughts or
> ideas. While there wasn't any new proposals, there was a question as
> to if anyone will really be running 32bit hardware in 2038, which made
> some folks point out that as systems get smaller there are likely to
> be tiny embedded platforms using Linux. The point that these systems

I'm pretty sure people will run 32bit hardware in 2038... that is not even
a question.

Today, there's good chance there's linux somewhere in your car. (Dashboard,
entertainment system). People like to keep cars from 1910 working, and I suspect
that is not going to change.

So yes, in 2038 people will be running 32bit linux.

Whether there will be people putting 32bit linux into new devices is a question,
but I suspect answer is still yes.
										Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
