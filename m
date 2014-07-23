Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577AbaGWU0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:26:53 -0400
Received: from imap.thunk.org ([74.207.234.97]:53117 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbaGWU0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:26:51 -0400
Date: Wed, 23 Jul 2014 16:26:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        acab@digitalfuture.it, stable@kernel.org
Subject: Re: [PATCH] random: fix 32MB+ reads from /dev/urandom
Message-ID: <20140723202641.GF6673@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, acab@digitalfuture.it,
	stable@kernel.org
References: <20140723171421.GA2997@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723171421.GA2997@p183.telecom.by>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this patch is worthwhile.  There is no legitimate reason
to be using such large reads like this, and read(2) is always allowed
to return a short read (for example, if a signal comes in while the
read is happening).  The only difference is that we are now guaranteed
to return a short-read if you try to read more than 32MB.  Given that
there is no valid reason to ask for more than 256 or maybe 512 bytes
at a time, I'm not particularly worried about this.

If you really care, you can ask dd keep reading after a short read by
using "iflag=fullblock".  

						- Ted
