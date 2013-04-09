Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3DIETB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 00:19:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3DIETA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 00:19:00 -0400
Date: Mon, 8 Apr 2013 21:18:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Chanho Min <chanho.min@lge.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Guennadi Liakhovetski <lg@denx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bitmap: speedup in bitmap_find_free_region when
 order is 0
Message-Id: <20130408211859.b5549325.akpm@linux-foundation.org>
In-Reply-To: <1365477500.2012.5.camel@joe-AO722>
References: <1365475486-14371-1-git-send-email-chanho.min@lge.com>
	<20130408201001.f4c74887.akpm@linux-foundation.org>
	<1365477500.2012.5.camel@joe-AO722>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Apr 2013 20:18:20 -0700 Joe Perches <joe@perches.com> wrote:

> On Mon, 2013-04-08 at 20:10 -0700, Andrew Morton wrote:
> > > --- a/lib/bitmap.c
> []
> > > +	for (i = 0 ; i < nlongs_reg ; i++) {
> > 
> > No space before the semicolon, please.  checkpatch should warn about
> > this but it seems to be broken.
> 
> There's no specific CodingStyle violation here

Let's fix CodingStyle then?  Nobody puts spaces before semis - perish
the thought!  (I count 4,254,057 versus 8,416 in .c)

> Adding --strict does bleat though.

And let's make it default please.

> # check for whitespace before a non-naked semicolon
> 		if ($line =~ /^\+.*\S\s+;/) {
> 			CHK("SPACING",
> 			    "space prohibited before semicolon\n" . $herecurr);
> 		}
> 
