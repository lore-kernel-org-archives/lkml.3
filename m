Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbaH0DVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 23:21:50 -0400
Received: from imap.thunk.org ([74.207.234.97]:51038 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277AbaH0DVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 23:21:49 -0400
Date: Tue, 26 Aug 2014 23:21:43 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Daniel Borkmann <dborkman@redhat.com>, zatimend@hotmail.co.uk,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] random: add and use memzero_explicit() for clearing data
Message-ID: <20140827032143.GQ11317@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Daniel Borkmann <dborkman@redhat.com>, zatimend@hotmail.co.uk,
	linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
References: <1408996899-4892-1-git-send-email-dborkman@redhat.com>
 <1409008290.6274.73.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409008290.6274.73.camel@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 01:11:30AM +0200, Hannes Frederic Sowa wrote:
> On Mo, 2014-08-25 at 22:01 +0200, Daniel Borkmann wrote:
> > zatimend has reported that in his environment (3.16/gcc4.8.3/corei7)
> > memset() calls which clear out sensitive data in extract_{buf,entropy,
> > entropy_user}() in random driver are being optimized away by gcc.
> > 
> > Add a helper memzero_explicit() (similarly as explicit_bzero() variants)
> > that can be used in such cases where a variable with sensitive data is
> > being cleared out in the end. Other use cases might also be in crypto
> > code. [ I have put this into lib/string.c though, as it's always built-in
> > and doesn't need any dependencies then. ]
> > 
> > Fixes kernel bugzilla: 82041
> > 
> > Reported-by: zatimend@hotmail.co.uk
> > Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> > Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Cc: Alexey Dobriyan <adobriyan@gmail.com>
> 
> Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Applied to the random tree, thanks.

					- Ted
