Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3FYNam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:30:42 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36000 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3FYNal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:30:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130625151151.73aaba28@mschwide>
References: <20130403172534.528d04c5@mschwide> <CACxGe6sYM8QPB-ZZkgB0+f81CZHULPi5zPAsWb5dzHiRgU+w6Q@mail.gmail.com>
 <20130625141508.6c391fd8@mschwide> <CACxGe6s3RqOkf=M4zwpJGEEVa9XjJvP2q5xeLKewGo6np5C-3g@mail.gmail.com>
 <20130625151151.73aaba28@mschwide>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 25 Jun 2013 14:30:20 +0100
X-Google-Sender-Auth: n15mEbLh2UuVlNuCEZzYPlHxvxI
Message-ID: <CACxGe6uOf+TONiCu27w9TsXmo2VVYXKS1+RZckAtxAdshtPDgQ@mail.gmail.com>
Subject: Re: [GIT PULL] s390 patches for the 3.9-rc6
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 2:11 PM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
> On Tue, 25 Jun 2013 13:42:23 +0100
> Grant Likely <grant.likely@secretlab.ca> wrote:
>
>> On Tue, Jun 25, 2013 at 1:15 PM, Martin Schwidefsky
>> <schwidefsky@de.ibm.com> wrote:
>> > On Tue, 25 Jun 2013 13:09:51 +0100
>> > Grant Likely <grant.likely@secretlab.ca> wrote:
>> >
>> >> On Wed, Apr 3, 2013 at 4:25 PM, Martin Schwidefsky
>> >> <schwidefsky@de.ibm.com> wrote:
>> >> > Hi Linus,
>> >> >
>> >> > please pull from the 'for-linus' branch of
>> >> >
>> >> >         git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus
>> >> >
>> >> > to receive the following updates: Just a bunch of bugfixes.
>> >> >
>> >> > Heiko Carstens (4):
>> >> >       drivers/Kconfig: add several missing GENERIC_HARDIRQS dependencies
>> >>
>> >> Is anyone currently working on fixing this? s390 is the only
>> >> architecture left that does not enable GENERIC_HARDIRQS. It's painful
>> >> to keep adding dependencies on GENERIC_HARDIRQS to driver configs.
>> >
>> > I am working on it. The hardest part is MSI irqs for PCI. Chances are
>> > that I get it done for the merge window of 3.12.
>>
>> How are you handling the MSIs? I've just been looking at some code for
>> irq_domain to handle MSI mapping. What's the part that is getting you
>> hung up?
>
> Basically a name-space thing. The current code allocates 64 interrupts numbers
> for each PCI device, starting at 0. With GENERIC_HARDIRQS=y irq #0 is used for
> for external interrupts, irq #1 for I/O interrupts and irq #2 for adapter
> interrupts. The adapter interrupt handler for PCI has to scan the interrupt
> vectors and call generic_handle_irq for the MSI interrupts starting at irq #3.
> As I don't want to create a huge irq_desc array the number of allocatable
> interrupts for MSI will be limited and I can not simply assign 64 interrupts
> numbers to each device anymore.

Have you looked at irq_domain? It was created to solve that exact
problem. irq_descs can get allocated dynamically as irqs are
requested.

g.
