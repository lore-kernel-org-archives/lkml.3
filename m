Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab3FYNMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:12:00 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:47608 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FYNL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:11:59 -0400
Date: Tue, 25 Jun 2013 15:11:51 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] s390 patches for the 3.9-rc6
Message-ID: <20130625151151.73aaba28@mschwide>
In-Reply-To: <CACxGe6s3RqOkf=M4zwpJGEEVa9XjJvP2q5xeLKewGo6np5C-3g@mail.gmail.com>
References: <20130403172534.528d04c5@mschwide>
	<CACxGe6sYM8QPB-ZZkgB0+f81CZHULPi5zPAsWb5dzHiRgU+w6Q@mail.gmail.com>
	<20130625141508.6c391fd8@mschwide>
	<CACxGe6s3RqOkf=M4zwpJGEEVa9XjJvP2q5xeLKewGo6np5C-3g@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062513-8372-0000-0000-00000667E96B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013 13:42:23 +0100
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Tue, Jun 25, 2013 at 1:15 PM, Martin Schwidefsky
> <schwidefsky@de.ibm.com> wrote:
> > On Tue, 25 Jun 2013 13:09:51 +0100
> > Grant Likely <grant.likely@secretlab.ca> wrote:
> >
> >> On Wed, Apr 3, 2013 at 4:25 PM, Martin Schwidefsky
> >> <schwidefsky@de.ibm.com> wrote:
> >> > Hi Linus,
> >> >
> >> > please pull from the 'for-linus' branch of
> >> >
> >> >         git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus
> >> >
> >> > to receive the following updates: Just a bunch of bugfixes.
> >> >
> >> > Heiko Carstens (4):
> >> >       drivers/Kconfig: add several missing GENERIC_HARDIRQS dependencies
> >>
> >> Is anyone currently working on fixing this? s390 is the only
> >> architecture left that does not enable GENERIC_HARDIRQS. It's painful
> >> to keep adding dependencies on GENERIC_HARDIRQS to driver configs.
> >
> > I am working on it. The hardest part is MSI irqs for PCI. Chances are
> > that I get it done for the merge window of 3.12.
> 
> How are you handling the MSIs? I've just been looking at some code for
> irq_domain to handle MSI mapping. What's the part that is getting you
> hung up?

Basically a name-space thing. The current code allocates 64 interrupts numbers
for each PCI device, starting at 0. With GENERIC_HARDIRQS=y irq #0 is used for
for external interrupts, irq #1 for I/O interrupts and irq #2 for adapter
interrupts. The adapter interrupt handler for PCI has to scan the interrupt
vectors and call generic_handle_irq for the MSI interrupts starting at irq #3.
As I don't want to create a huge irq_desc array the number of allocatable
interrupts for MSI will be limited and I can not simply assign 64 interrupts
numbers to each device anymore.

> I'd be happy to take a look if you want a hand.

Thanks for the offer, I might take you up on it if I hit a real problem.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

