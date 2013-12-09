Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523Ab3LITNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:13:53 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46135 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761202Ab3LITNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:13:52 -0500
Date: Mon, 9 Dec 2013 20:13:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] softirq: Use ffs in __do_softirq
Message-ID: <20131209191348.GB1811@localhost.localdomain>
References: <cover.1384656563.git.joe@perches.com>
 <8d10077333476c5c0e054cf060006999cf150f0c.1384656563.git.joe@perches.com>
 <20131209184454.GA1811@localhost.localdomain>
 <1386615406.8168.16.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386615406.8168.16.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 10:56:46AM -0800, Joe Perches wrote:
> On Mon, 2013-12-09 at 19:44 +0100, Frederic Weisbecker wrote:
> > On Sun, Nov 17, 2013 at 01:55:10AM -0800, Joe Perches wrote:
> > > Possible speed improvement of the __do_softirq function by using ffs
> > > instead of using a while loop with an & 1 test then single bit shift.
> []
> > Perhaps using for_each_set_bit() would simplify that more?
> 
> It might simplify the appearance of the code but it
> would/could expand the amount of generated code because
> for_each_set_bit uses an address_of(unsigned long) and
> the value tested is an unsigned int.
> 
> extra dereferences, can't be in a register, etc...

I'm not sure that would matter that much. But yeah it appears that find_first_bit/find_next_bit
aren't even overriden in x86. So they are function calls. Although I guess that most
of the time only one softirq is pending at a time.

But anyway perhaps we want that path to stay very optimized, so you're
patch look ok.

Thanks.
