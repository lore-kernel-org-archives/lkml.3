Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab3LSBhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:37:10 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:38199 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3LSBhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:37:08 -0500
Date: Wed, 18 Dec 2013 17:37:04 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] closures: move to lib/
Message-ID: <20131219013704.GE4054@kmo>
References: <1387416594-23930-1-git-send-email-kmo@daterainc.com>
 <CAPcyv4gBN4M312WRmAvwHbTjMspiSTPuFyir_fc3nH6akpgosw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gBN4M312WRmAvwHbTjMspiSTPuFyir_fc3nH6akpgosw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 05:34:31PM -0800, Dan Williams wrote:
> On Wed, Dec 18, 2013 at 5:29 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> > the closure code was never intended to be bcache specific - hopefully it can be
> > useful elsewhere in the kernel.
> >
> > Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Arjan van de Ven <arjan@linux.intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/md/bcache/Kconfig   |   9 -
> >  drivers/md/bcache/Makefile  |   2 +-
> >  drivers/md/bcache/bcache.h  |   2 +-
> >  drivers/md/bcache/closure.c | 222 ----------------------
> >  drivers/md/bcache/closure.h | 453 --------------------------------------------
> >  drivers/md/bcache/util.h    |   3 +-
> >  include/linux/closure.h     | 451 +++++++++++++++++++++++++++++++++++++++++++
> >  lib/Kconfig.debug           |   8 +
> >  lib/Makefile                |   2 +-
> >  lib/closure.c               | 218 +++++++++++++++++++++
> >  10 files changed, 681 insertions(+), 689 deletions(-)
> >  delete mode 100644 drivers/md/bcache/closure.c
> >  delete mode 100644 drivers/md/bcache/closure.h
> >  create mode 100644 include/linux/closure.h
> >  create mode 100644 lib/closure.c
> 
> This would be smaller to review with git diff -M

I forgot to mention - this is on top of other stuff I have queued up which
deletes a fair amount of code in closure.[ch] (finally got rid of some stuff
Tejun hated).
