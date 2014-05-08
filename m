Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaEHOem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:34:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39304 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753205AbaEHOel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:34:41 -0400
Date: Thu, 8 May 2014 15:34:07 +0100
From: Will Deacon <will.deacon@arm.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kay@vrfy.org" <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: +
 printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch
 added to -mm tree
Message-ID: <20140508143407.GB8981@arm.com>
References: <53640c8c.5++0zeO0pmfqKMwm%akpm@linux-foundation.org>
 <20140502224651.GG23636@quack.suse.cz>
 <20140506120648.GA30234@arm.com>
 <20140506122958.GG9291@quack.suse.cz>
 <20140506131234.GD30234@arm.com>
 <20140506150553.a12959fd71d83eddcb4b325d@linux-foundation.org>
 <20140507095850.GC18456@arm.com>
 <20140507174151.3c28f15a@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507174151.3c28f15a@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, May 07, 2014 at 05:41:51PM +0100, One Thousand Gnomes wrote:
> > Possibly, but I fear we'd incur the wrath of Alan after reading that other
> > thread. Having a CONFIG_ option or similar to control the amount of printing
> > we do is very similar to the command-line option Jan proposed in his series.
> 
> I've nothing against a configuration option, and having a printk that
> queued most stuff to the serial IRQ handler on overflow and a boot option
> of printk=synchronous for debug work would be awesome in my book. Many end
> production boxes don't give a toss about losing the odd bit of data they
> just need to shift the logs somewhere for filing.

Ok, I'll revisit this with a command-line option for the debug case. Thanks.

> All these "clever" approaches just seem to me to be ever more convoluted
> attempts to fail to deal with the simple reality that if you put more
> down the sewage pipe than fits it has to overflow somewhere.
>
> Our tty drivers have a fifo, our tty drivers have an IRQ driven write
> operation. It seems silly to be adding magic to solve the problem rather
> than just using it (and in turn getting a ton of other consoles for free,
> and being able to take GregKH's current usb console hack out)

Hmm, I'm not at all familiar with the tty layer, so I'd have to go and take
a look. Jan, did you look at this at all?

Will
