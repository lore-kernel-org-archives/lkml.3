Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaIVREL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:04:11 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48221 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaIVREJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:04:09 -0400
X-Originating-IP: 75.92.167.159
Date: Mon, 22 Sep 2014 10:03:46 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Support compiling out madvise and fadvise
Message-ID: <20140922170345.GD25352@thin>
References: <20140922161109.GA25027@thin>
 <1411404460.28679.12.camel@linux-t7sj.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411404460.28679.12.camel@linux-t7sj.site>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 06:47:40PM +0200, Davidlohr Bueso wrote:
> On Mon, 2014-09-22 at 09:11 -0700, Josh Triplett wrote:
> > Many embedded systems will not need these syscalls, and omitting them
> > saves space.  Add a new EXPERT config option CONFIG_ADVISE_SYSCALLS
> > (default y) to support compiling them out.
> 
> general question: if a user chooses CONFIG_ADVISE_SYSCALLS=n (or any
> config option related to tinyfication) and breaks the system/workload...
> will that be acceptable for a kernel pov? In other words, what's the
> degree of responsibility the user will have when choosing such builds?

It's hidden behind EXPERT for exactly that reason: if you turn it off,
and your userspace needs it and can't cope with ENOSYS, you get to keep
all the pieces.  Only turn it off if you know your userspace doesn't
use it.

The same thing goes for several other such options, such as UID16,
SYSCTL_SYSCALL, SGETMASK_SYSCALL, and USELIB.

- Josh Triplett
