Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaBDRIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:08:45 -0500
Received: from imap.thunk.org ([74.207.234.97]:54113 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807AbaBDRIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:08:41 -0500
Date: Tue, 4 Feb 2014 12:08:23 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de, sandyinchina@gmail.com
Subject: Re: [RFC PATCH 0/5] CPU Jitter RNG
Message-ID: <20140204170823.GF12768@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
	blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
	tg@mirbsd.de, sandyinchina@gmail.com
References: <2039634.jSmQAS6tdi@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2039634.jSmQAS6tdi@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I really wish we could get someone inside Intel who has deep knowledge
about CPU internals to render an opinion about this.  My reaction to
"I can't explain where the entropy is coming from" seems very similar
to what my home grown attempts to create an encryption algoritm when I
was much younger and much more foolish --- "it must be secure because
I can't break it".

I will note that there are parts of 

> [2] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html

which don't really add much to the discussion, but instead just simply
make an expert question how deep the analysis has gone.  Measuring the
statistical tests of the entropy pool is a complete waste of time ---
and in general, using things like "dieharder" don't do anything to
increase one's confidence (and could decrease one's confidence if it
makes it appear too much like a snake oil sales document).  Sure,
passing dieharder is necessary, but it isn't even vaguely close to
sufficient.

Modulo questions of how much CPU overhead it has, I wouldn't have an
objection to adding additional sources into the entropy pool, such as
what Joern has suggested.  It's when there is a proposal to give such
output entropy credit that I start to get queasy.  (But then again,
since most applications uses /dev/urandom, the question of entropy
credit isn't that important for many use cases.)

       	     	  	    	     	 - Ted

