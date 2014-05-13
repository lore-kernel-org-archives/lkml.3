Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838AbaEMLP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:15:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaEMLP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:15:26 -0400
Date: Tue, 13 May 2014 13:15:24 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Brian Norris <computersforpeace@gmail.com>, "Gupta, Pekon" <pekon@ti.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mtd: Add sysfs attr to expose ECC stats
Message-ID: <20140513111524.GA29552@kroah.com>
References: <1395403064-28113-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1395403064-28113-2-git-send-email-ezequiel.garcia@free-electrons.com>
 <20980858CB6D3A4BAE95CA194937D5E73EAB91D7@DBDE04.ent.ti.com>
 <20140401111359.GA3324@arch.cereza>
 <20980858CB6D3A4BAE95CA194937D5E73EAC31AE@DBDE04.ent.ti.com>
 <20140513005053.GZ28907@ld-irv-0074>
 <20140513022614.GA1447@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513022614.GA1447@arch.cereza>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 11:26:14PM -0300, Ezequiel Garcia wrote:
> On 12 May 05:50 PM, Brian Norris wrote:
> > > There are some guidelines about attributes in 'Documentation/filesystems/sysfs.txt'
> > > Though it's acceptable to put array of values of the "same type" in single sysfs file,
> > > But I'm still not confident on having all members of 'struct ecc_stats' being
> > > represented by single sysfs file
> > [...]
> > 
> > I agree, it looks like the sysfs policy would recommend against putting
> > distinct properties in the same file.
> > 
> 
> OK...
> 
> > I'm not sure if /sys/block/<disk>/stat is a good example, as it does
> > violate this policy. It also seems to have some historical baggage.
> > 
> > But there is potentially one good reason for putting this distinct
> > information in a single file: if the information must be returned
> > atomically. For disk stats, it might be important to get a consistent
> > snapshot of the disk stats (or nearly so, with minimal locking
> > overhead), which might change significantly between file accesses if
> > we're doing half a dozen file queries instead.
> > 
> > This same reason may not apply to these ECC stats, since none of these
> > ECC stats are likely to be changing concurrently.
> > 
> 
> Right.
> 
> > So I personally might lean toward "one file per attribute" here.
> > 
> 
> Yup, no problem. Greg, if you can confirm this it'd be great.

Yes, that is the rule for sysfs, please do not put multiple values in a
single sysfs file for a variety of good reasons.

> > > >> I hope this will still keep it machine readable.
> > > >Well, this is not a debugfs entry, so I'm not sure we want to add such debug
> > > >information. Anyone can take a look at the code and see what ecc_stats mean.
> > 
> > The code or (as suggested by Pekon) the documentation
> > (Documentation/ABI/). Either way -- with a single 'ecc_stats' table, or
> > with 4 separate files -- they need to be documented.
> > 
> 
> Sure, will document in next round.

This documentation is required, thanks.

greg k-h
