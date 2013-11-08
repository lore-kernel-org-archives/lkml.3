Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3KHQZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:25:19 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44394 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759Ab3KHQZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:25:13 -0500
Date: Fri, 8 Nov 2013 11:25:02 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
Message-ID: <20131108162502.GA16052@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
 <20131106153429.GA26336@redhat.com>
 <20131106155445.GB6357@neilslaptop.think-freely.org>
 <1383758363.7940.19.camel@joe-AO722>
 <20131106200204.GB11415@hmsreliant.think-freely.org>
 <1383768458.7940.33.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383768458.7940.33.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 12:07:38PM -0800, Joe Perches wrote:
> On Wed, 2013-11-06 at 15:02 -0500, Neil Horman wrote:
> > On Wed, Nov 06, 2013 at 09:19:23AM -0800, Joe Perches wrote:
> []
> > > __always_inline instead of inline
> > > static __always_inline void prefetch_lines(const void *addr, size_t len)
> > > {
> > > 	const void *end = addr + len;
> > > ...
> > > 
> > > buff doesn't need a void * cast in prefetch_lines
> > > 
> > Actually I take back what I said here, we do need the cast, not for a conversion
> > from unsigned char * to void *, but rather to discard the const qualifier
> > without making the compiler complain.
> 
> Not if the function is changed to const void *
> and end is also const void * as shown.
> 
Addr is incremented in the for loop, so it can't be const.  I could add a loop
counter variable on the stack, but that doesn't seem like it would help anything

Neil

> 
> 
