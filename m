Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934730AbaE3XJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 19:09:09 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62213 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaE3XJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 19:09:06 -0400
MIME-Version: 1.0
In-Reply-To: <1401483970.14938.38.camel@pasglop>
References: <1395903457.5569.89.camel@pasglop> <20140530030618.5ad4f447@Vantage>
 <1401446278.14938.26.camel@pasglop> <20140530095822.3588a6ff@Vantage>
 <CAAMCDecAgn=FX4Lw4YK_z4OKZsKqaj3scXe2cg0HN9tSj_FokA@mail.gmail.com> <1401483970.14938.38.camel@pasglop>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 30 May 2014 18:08:45 -0500
Message-ID: <CAAMCDecCe6tcKcCCShz-TpwamucLhwp8s_a_KSc8OvQ3GLAFtg@mail.gmail.com>
Subject: Re: Bad DMA from Marvell 9230
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: =?ISO-8859-1?Q?J=E9r=F4me_Carretero?= <cJ-ko@zougloub.eu>,
        Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-ide <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pretty much any smartcommands...I was running something that got all
of the smart stats 1x per hour per disk...and this made it crash about
1x per week, if you were pushing the disks hard it appear to make it
even more likely to crash under the smart cmds, removing the commands
took things up to 2-3 months between crashes.

I suspect if you just put a simple smartcmd --all /dev/sdX and ran it
a few times a minute if it had the issue it would almost certainly
crash in less than a day, I did not figure out the smart cmds were
crashing it, someone else's post indicate that they had determined
that and I figured out what I had doing smartcmds and removed them and
things got much betterr.

For finding good vendors, I know others on the md-raid list have given
up on cheap and found decent but more expensive controllers.

I would expect LSI and Adaptec to care enough about their names to
make a decent quality product.   There appears to be  4pt (1-8087
pt-jbod/nonraid) adaptec that may be some variant of marvell that is
about $130US on newegg, given it is adaptec they may have made the
marvell actually work.   There are a number of 8pt non-raid cards up
around $250-$300 that would probably work great if you wanted to pay
that much, these cards have 2x8087 ports and need a 8087->4sata cable
cable.   Given how nice it is to have a machine that just mostly works
without messing around with it I would probably pay the extra for
stability.

Last time I looked at the 2pt/pciex1 cards I found significant
indications of instability enough to expect that I would have to put
several hours (or more) of testing/crashing/RMA  pain in to figure out
which worked.    I went so far as crossing out any of the motherboards
with non-AMD/non-intel sata ports as I have been burned before on
large MB vendors doing a bad job of integrating others (possibly bad)
sata ports in, it is a sad state, but it also has been this way for a
long time.
