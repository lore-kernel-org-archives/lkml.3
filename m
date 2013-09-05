Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3IEOsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:48:25 -0400
Received: from imap.thunk.org ([74.207.234.97]:55094 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab3IEOsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:48:23 -0400
Date: Thu, 5 Sep 2013 10:48:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random, Add user configurable get_bytes_random()
Message-ID: <20130905144818.GA23661@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
References: <1378383524-27983-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378383524-27983-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 08:18:44AM -0400, Prarit Bhargava wrote:
> The current code has two exported functions, get_bytes_random() and
> get_bytes_random_arch().  The first function only calls the entropy
> store to get random data, and the second only calls the arch specific
> hardware random number generator.
> 
> The problem is that no code is using the get_bytes_random_arch() and switching
> over will require a significant code change.  Even if the change is
> made it will be static forcing a recompile of code if/when a user has a
> system with a trusted random HW source.  A better thing to do is allow
> users to decide whether they trust their hardare random number generator.

I fail to see the benefit of just using the hardware random number
generator.  We are already mixing in the hardware random number
generator into the /dev/random pool, and so the only thing that using
only the HW source is to make the kernel more vulnerable to an attack
where the NSA leans on a few Intel employee and forces/bribes them to
make a change such that the last step in the RDRAND's AES whitening
step is changed to use a counter plus a AES key known by the NSA.

     		       	 	      - Ted
