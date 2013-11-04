Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab3KDQdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:33:00 -0500
Received: from imap.thunk.org ([74.207.234.97]:54124 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab3KDQc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:32:58 -0500
Date: Mon, 4 Nov 2013 11:32:48 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH -next] random: needs linux/device.h for struct device
Message-ID: <20131104163248.GC7108@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20131104175916.763e3c0cf001b9f948f2baa7@canb.auug.org.au>
 <5277C5F8.3080609@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5277C5F8.3080609@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 08:06:16AM -0800, Randy Dunlap wrote:
> on x86_64:
> 
> drivers/char/random.c: In function 'add_device_attach_randomness':
> drivers/char/random.c:837:41: error: dereferencing pointer to incomplete type
> 
> 
> need to #include <linux/device.h> for struct device, I think.

The patch which introduced this is going to be dropped from the random
tree because I'm concerned the amount of entropy that will be added
will get overstated, especially on CPU's that don't have cycle
counters (ARM and MIPS in particular).

I plan to rework it to be safer, although I suspect using device
attach times simply won't be doable on CPU's that don't have a cycle
counter register, or some other fine-grained, highly light-weight
timer (I can't use the clocksource infrastructure since those time
sources are not necessarily available during early boot, and there is
no guarantee how expensive some of the clock sources might be; some
can be quite expensive, <cough> IBM X440 servers with their
"scalability cable" <cough>).

	   	       	    	    	 - Ted
