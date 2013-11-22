Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab3KVQDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:03:00 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:63622 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3KVQC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:02:59 -0500
Date: Fri, 22 Nov 2013 11:02:52 -0500
From: Tejun Heo <tj@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH] sysfs: handle duplicate removal attempts in
 sysfs_remove_group()
Message-ID: <20131122160252.GA8981@mtj.dyndns.org>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
 <20131120061830.GA16081@mtj.dyndns.org>
 <CAErSpo5s9chjgSaA2kqE_72f=+2Lq9HQLM3xstw8Avg+Nx63xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5s9chjgSaA2kqE_72f=+2Lq9HQLM3xstw8Avg+Nx63xA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 22, 2013 at 08:43:55AM -0700, Bjorn Helgaas wrote:
> > So, we do have cases where the parent is removed before the child.  I
> > suppose the parent pci bridge is removed already?  AFAICS this
> > shouldn't break anything but people did seem to expect the removals to
> > be ordered from child to parent.  Bjorn, is this something you expect
> > to happened?
> 
> I do not expect a PCI bridge to be removed before the devices below
> it.  We should be removing all the children before removing the parent
> bridge.
> 
> But is this related to PCI?  I don't see the connection yet.  I tried

I'm not sure.  It was from thunderbolt and nobody is reporting it on
other interconnects, so it could be.

> to look into this a bit (my notes are at
> https://bugzilla.kernel.org/show_bug.cgi?id=65281), but I haven't
> figured out the big-picture problem yet.
> 
> I don't have warm fuzzies that adding a "have we already removed this"
> check is the best resolution, but maybe that's just because I don't
> understand the problem.

Yeah, the whole thing is sorta pointless.  Just issuing removal and
continuing on should do, IMHO.

Thanks.

-- 
tejun
