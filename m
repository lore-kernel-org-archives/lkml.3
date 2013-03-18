Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122Ab3CREVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:21:42 -0400
Received: from nctlincom01.orcon.net.nz ([60.234.4.69]:55044 "EHLO
	nctlincom01.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3CREVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:21:38 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2013 00:21:38 EDT
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Message-Id: <BFB01C0A-95E5-4C2B-8AF2-A06BE1FF74E0@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Will Deacon <will.deacon@arm.com>
In-Reply-To: <1363556926-21097-1-git-send-email-will.deacon@arm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH] alpha: makefile: don't enforce small data model for kernel builds
Date: Mon, 18 Mar 2013 17:11:15 +1300
References: <1363556926-21097-1-git-send-email-will.deacon@arm.com>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx6.orcon.net.nz on Mon, 18 Mar 2013 17:11:43 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Mar 18 17:11:44 2013
X-DSPAM-Confidence: 0.6519
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0147 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: -3.00 () [Hold at 4.00] CC(NZ:-3)
X-CanIt-Geo: ip=130.217.188.11; country=NZ; region=G1; city=Hamilton; latitude=-37.7833; longitude=175.2833; http://maps.google.com/maps?q=-37.7833,175.2833&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 06JcQhc8h - 75285e8fa6c3 - 20130318
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/03/2013, at 10:48 AM, Will Deacon wrote:
> Due to all of the goodness being packed into today's kernels, the
> resulting image isn't as slim as it once was.
>
> In light of this, don't pass -msmall-data to the tools, which  
> results in
> link failures due to impossible relocations when compiling anything  
> but
> the most trivial configurations.

I think many of us have been using -mlarge-data when compiling with  
gcc-4.6 or later so maybe it is time to get the change upstream.

The interesting thing is that the kernel still compiles fine with  
gcc-4.5 and the relocation errors only appear if compiling with  
gcc-4.6 or later.  I had asked before on this forum what had changed  
with gcc-4.6 that results in the extra usage of the small data area  
but never got an answer.  I am still curious to know.

BTW, the phrase "to the tools" in the commit message makes me think  
immediately of the tools directory (containing perf, etc.) which is  
not what is intended.

Matt:  Are you able to collect up this and the other patches of Will  
and get them sent to Linus?

Cheers
Michael.

