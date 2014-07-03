Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaGCGLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 02:11:10 -0400
Received: from moi001.1and1.com ([212.227.126.208]:56732 "EHLO moi.1and1.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaGCGLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 02:11:08 -0400
Message-ID: <53B4F3D9.8050009@1und1.de>
Date: Thu, 03 Jul 2014 08:10:33 +0200
From: =?ISO-8859-1?Q?Thomas_Sch=F6bel-Theuer?= <tst@1und1.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Thomas Schoebel-Theuer <tst@schoebel-theuer.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 49/50] mars: generic pre-patch for mars
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de> <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de> <20140701223644.GA30330@kroah.com> <53B3B283.7050800@schoebel-theuer.de> <20140702082400.GB10971@kroah.com> <20140702132708.GA26732@infradead.org> <53B418FA.80600@1und1.de> <20140702145024.GA19425@infradead.org> <53B43144.6010306@1und1.de> <20140702184143.GA3061@infradead.org>
In-Reply-To: <20140702184143.GA3061@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Please take into account that MARS Light is not just a "device driver",
>> but a long-distance distributed system dealing with huge masses of state
>> information.
> Which doesn't matter.  No kernel driver has a business messing with the
> filesystem namespace.  Especially no maintaining magic symlink farms.
>

I see the following alternative solutions for this:

a) MARS Light cannot go upstream because it is viewed as a driver
violating the rules. In this case, I could retry submission some years
laters when (subsets of) MARS Full strictly obey some hierarchy rules
which I have to know completely in advance in order to no longer make
any mistakes. However, I am not sure whether the limits in the solution
space are really appropriate for the problem space; I would have to make
new prototype implementations and compare them to other solutions. Only
after that, I would be able to decide whether to go upstream at all, or
to continue an out-of-tree project.

or

b) you permit me exceptions from the rules, justified by the fact that a
_distributed_ "driver" for long-distance replication of terabytes of
data (constructed for long-distance replication of _whole_ _datacenters_
) needs dynamically growing storage space for bulk data. In order to not
re-invent the wheel, you permit me storing both data and metadata in a
reserved filesystem instance. Storing metadata _together_ with the
_corresponding_ (!) bulk data is justified by the fact that separate
storage spaces would need some additional means for ensuring
_consistency_ between them in case of node failures etc.

or

c) MARS Light is viewed as a distributed system, similar to a cluster
filesystem, which just happens to export a block device to userspace (at
current stage of development; notice that the generic brick framework is
not limited to the block device layer).

or

d) both MARS Light and the future Full is viewed as a new generic
framework. In current stage, only some parts dealing with block devices
are implemented. In later stages of MARS Full, the future hierarchy
rules will be automatically checked / established by some future
strategy bricks, according to IOP design principles as proposed in my
papers / in my monography (a detailed discussion is probably out of
scope of this discussion).

Possibly there are further alternatives.

At least in cases c) and d), the sourcecode should IMHO not go to
drivers/block/ but somewhere else (please give me some suggestions; this
is why ./rework-mars-for-upstream.pl has is easily configurable).

Cheers,

Thomas

