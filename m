Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaFODTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 23:19:19 -0400
Received: from imap.thunk.org ([74.207.234.97]:39328 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbaFODTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 23:19:18 -0400
Date: Sat, 14 Jun 2014 23:19:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        George Spelvin <linux@horizon.com>
Subject: Re: Surprising 64-bit performance anomaly (was Re: [PATCH] random:
 use an improved fast_mix() function)
Message-ID: <20140615031913.GB8111@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	George Spelvin <linux@horizon.com>
References: <1402798797-26251-1-git-send-email-tytso@mit.edu>
 <20140615030441.GA8111@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615030441.GA8111@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 11:04:41PM -0400, Theodore Ts'o wrote:
> Hi George,
> 
> On top of the above patch, I applied the following to add 64-bit pool
> support.  I had to use a union to avoid type punning warnings.
> 
> When building a 64-bit kernel and running under under KVM, I'm finding
> that the 64-bit mix function which you suggested is twice as slow.
> 
> Using the (new) 32-bit function:
> 
> 31821 23970
> 31629 24366
> 30856 24182
> 
> Using the 64-bit mixing function:
> 
> 60438 44369
> 60820 45402
> 58778 45419

I'm now getting a different set of timing numbers for the 64-bit
mixing function.  As before the first number is the weighted moving
average; the second is the deviation:

48035 34322
47452 34413
46974 34350

I'm not sure why I'm getting slightly better figures now, but it's
still worse than the 32-bit fast_mix3() algorithm.  Also, given the
additional complexity I'm not sure it's worth it to have a different
mixing algorithm for 64-bit platforms, unless it's significantly
better, and right now, I'm seeing numbers which are about 50% worse,
at least on my test platform.

	   	      	      	   	      - Ted
