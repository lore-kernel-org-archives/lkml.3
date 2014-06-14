Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaFNQdm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 12:33:42 -0400
Received: from imap.thunk.org ([74.207.234.97]:39009 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbaFNQdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 12:33:41 -0400
Date: Sat, 14 Jun 2014 12:33:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Message-ID: <20140614163334.GJ6447@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140614111405.9630.qmail@ns.horizon.com>
 <20140614151314.2721.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140614151314.2721.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, using your averaging scheme, on a 32-bit KVM kernel, running at
idle, here are my quick results:

Original

48028 51419
46021 50065
44750 49231

Fastmix 2, 3 interations

95956 58313    
97295 57599
97242 56942

Fastmix 2, 2 iterations

68998 41496
68940 41471
68619 41576

Fastmix 2, 2 iterations, unrolled

48725 39281
48313 38424
47349 37847

So with two iterations are at least no worse than before (and in fact
the deviation is less, which makes sense since we don't have the
twist_array memory accesses), and I can easily believe there will be
architectures/microarchitectures where it will be better.

I'll need to do a bit more looking to convince myself that 2
iterations is better from a mixing perspective, but this looks like it
might be a promising replacement for the 32-bit mixer.

      	   	     		     	 	- Ted
