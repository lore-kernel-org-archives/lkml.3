Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3LTAzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 19:55:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3LTAzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 19:55:23 -0500
Date: Thu, 19 Dec 2013 16:55:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to reserve pci bus numbers for hotplug?
Message-ID: <20131220005526.GB17307@kroah.com>
References: <CAMxnaaWgUPRb3L2aKpUu62F73GR2iXOfd6LUnTkU0O=Gq-E_sQ@mail.gmail.com>
 <20131214220145.GA27585@kroah.com>
 <CAMxnaaXzvxTJc+fP_E9fQhMTsVcj2PCJCsp=PNae3Pv47JONdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMxnaaXzvxTJc+fP_E9fQhMTsVcj2PCJCsp=PNae3Pv47JONdQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 11:15:39PM +0100, Andreas Noever wrote:
> On Sat, Dec 14, 2013 at 11:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Thu, Dec 12, 2013 at 12:37:50AM +0100, Andreas Noever wrote:
> >>
> >> If I could get Linux to assign enough resources (bus numbers for now)
> >> then I could drop the acpi_osi parameter and make thunderbolt work
> >> after suspend... So, is there an easy way to fix this? (Quirks,
> >> reconfiguring bus number assignments from a platform driver, ...?)
> >
> > I think you are going to have to do a lot more here, what is needed is a
> > whole connection manager for Thunderbolt, emulating what the BIOS does,
> > in order to get all of this working properly.
> >
> > But don't let that stop you from trying, however the work involved is
> > really not trivial at all.
> >
> > good luck,
> >
> > greg k-h
> 
> Actually the thunderbolt part is already working (for non chaining
> devices, see https://lkml.org/lkml/2013/11/28/492 if you are
> interested). I can completely bootstrap the tb side of things. The
> only problem is that if power has been cut by the firmware (during
> boot without osi_acpi=Darwin or after a suspend/resume cycle) then
> Linux does not allocate enough PCI resources...

Ah, that's nice to know, I didn't realize that.

There should be some Intel people around on the list that has access to
a Thunderbolt monitor for testing.  Or, if needed, I can see if I can
expense one, as it would be good to get this working :)

thanks,

greg k-h
