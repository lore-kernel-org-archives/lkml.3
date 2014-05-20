Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaETE2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 00:28:41 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:59769 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaETE2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 00:28:40 -0400
Date: Mon, 19 May 2014 21:28:49 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: alexandre.belloni@free-electrons.com, boris.brezillon@free-electrons.com,
        Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linus.walleij@linaro.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.16 #1
Message-ID: <20140520042849.GB18956@quad.lixom.net>
References: <1399484042-27432-1-git-send-email-nicolas.ferre@atmel.com>
 <536A6FD7.40402@atmel.com>
 <20140516232635.GB6423@quad.lixom.net>
 <20140516233141.GC6423@quad.lixom.net>
 <537A1EE8.6030303@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537A1EE8.6030303@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 05:10:32PM +0200, Nicolas Ferre wrote:
> On 17/05/2014 01:31, Olof Johansson :
> > On Fri, May 16, 2014 at 04:26:35PM -0700, Olof Johansson wrote:
> >> On Wed, May 07, 2014 at 07:39:35PM +0200, Nicolas Ferre wrote:
> >>> On 07/05/2014 19:34, Nicolas Ferre :
> >>>> Arnd, Olof, Kevin,
> >>>>
> >>>> This is the first cleanup pull-request for 3.16. It is pretty big because it
> >>>> integrates the work from Boris about CCF and Alexandre about IIO/ADC. I
> >>>> integrated them in this cleanup topic because they both touch the core at91
> >>>> code, the clk and IIO drivers as well as the DT. The concerned maintainers
> >>>> added their tags.
> >>>>
> >>>> The patch by Linus is a move of at91 specific GPIO definitions out of the
> >>>> include/mach directory which is an step towards single zImage.
> >>>>
> >>>> Thanks, best regards,
> >>>>
> >>>> The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:
> >>>>
> >>>>   Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)
> >>>>
> >>>> are available in the git repository at:
> >>>>
> >>>>   git://github.com/at91linux/linux-at91.git tags/at91-cleanup
> >>>
> >>> There is a little conflict with at91-3.16-dt that you already pulled in
> >>> arm-soc: here is the branch that resolves it:
> >>>
> >>> https://github.com/at91linux/linux-at91/commits/at91-3.16-resolved
> >>
> >> That resolution looks odd. Why is one clock under clocks { } and two of them
> >> are at the top level? Shouldn't they all be under the clocks subnode?
> >>
> >> I've merged in now with your resolution, but I think this needs revisiting.
> 
> With information from Alexandre, I have the feeling that we should
> remove the "clocks" container altogether. I propose to clean completely
> this part in 3.17 as it will not change the system but only its
> representation in DT...
> Still, we will fix the ugliest parts like this one:
> http://code.bulix.org/by22lb-86239

Right, that should be changed in one direction or another -- as mentioned in
my other reply just now I care more about consistency than the option you end
up choosing even though it does make some sense to me to group the clocks.

Either way, please follow up with patches instead of a pull request,
please, since there's no good way for you to base a pull request on top
of the merge-conflict-resolved resulting branch in our tree.

> > Oh, and also: The branch was named cleanup, but it really contains mostly new
> > driver and new contents, so I merged it under next/soc instead. In the future,
> > for releases when you have more contents, please split it up a bit more (dt
> > updates separately, driver updates separately) if it can be done without too
> > much hassle. For now it's not a huge deal to do it this way though.
> 
> Yes. The issue with these series that switch from one description to
> another is that if we split the driver and dt parts it would add extra
> steps which are not very easy to keep in sync, implement and are kind of
> useless.
> 
> I have more series to come for 3.16 that I named "cleanup" as well. I
> will double check to see if I can split them up more...

Ok. :) No worries. Getting used to splitting up takes a little while and it's
usually not a big deal -- you can still base the branches on top of each other
just cut them into separate pull requests. I can elaborate if you want.


-Olof
