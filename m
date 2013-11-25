Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab3KYK3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:29:18 -0500
Received: from mx2.parallels.com ([199.115.105.18]:58844 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3KYK3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:29:17 -0500
From: James Bottomley <jbottomley@parallels.com>
To: Tejun Heo <tj@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] sysfs: handle duplicate removal attempts in
 sysfs_remove_group()
Thread-Topic: [PATCH] sysfs: handle duplicate removal attempts in
 sysfs_remove_group()
Thread-Index: AQHO55mz/5WOCjnY10a/r5QcfC5U6Zox74EAgARZtYA=
Date: Mon, 25 Nov 2013 10:29:00 +0000
Message-ID: <1385375339.2354.28.camel@dabdike>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
	 <20131120061830.GA16081@mtj.dyndns.org>
	 <CAErSpo5s9chjgSaA2kqE_72f=+2Lq9HQLM3xstw8Avg+Nx63xA@mail.gmail.com>
	 <20131122160252.GA8981@mtj.dyndns.org>
In-Reply-To: <20131122160252.GA8981@mtj.dyndns.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [195.214.232.10]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <40D3E5B41E38204DA8EAC6B2D79E98CA@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 11:02 -0500, Tejun Heo wrote:
> Hello,
> 
> On Fri, Nov 22, 2013 at 08:43:55AM -0700, Bjorn Helgaas wrote:
> > > So, we do have cases where the parent is removed before the child.  I
> > > suppose the parent pci bridge is removed already?  AFAICS this
> > > shouldn't break anything but people did seem to expect the removals to
> > > be ordered from child to parent.  Bjorn, is this something you expect
> > > to happened?
> > 
> > I do not expect a PCI bridge to be removed before the devices below
> > it.  We should be removing all the children before removing the parent
> > bridge.
> > 
> > But is this related to PCI?  I don't see the connection yet.  I tried
> 
> I'm not sure.  It was from thunderbolt and nobody is reporting it on
> other interconnects, so it could be.
> 
> > to look into this a bit (my notes are at
> > https://bugzilla.kernel.org/show_bug.cgi?id=65281), but I haven't
> > figured out the big-picture problem yet.
> > 
> > I don't have warm fuzzies that adding a "have we already removed this"
> > check is the best resolution, but maybe that's just because I don't
> > understand the problem.
> 
> Yeah, the whole thing is sorta pointless.  Just issuing removal and
> continuing on should do, IMHO.

I'd go for that as well.  We have huge problems with the _del calls
because visibility is strict hierarchy and it's not always easy to work
out who's underneath us.

It's going to be really annoying when refcounting works perfectly for
objects, so you can just do puts in any order, but you have to have
_del() called to remove subordinate objects before their parent.

James

