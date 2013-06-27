Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3F0NwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:52:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56077 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3F0NwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:52:14 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 27 Jun 2013 06:52:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH] uio: uio_pci_generic: Add support for MSI interrupts
Message-ID: <20130627135220.GA5518@roeck-us.net>
References: <1372285823-6293-1-git-send-email-linux@roeck-us.net>
 <20130627074501.GC5489@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627074501.GC5489@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 10:45:01AM +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 26, 2013 at 03:30:23PM -0700, Guenter Roeck wrote:
> > Enable support for MSI interrupts if the device supports it.
> > Since MSI interrupts are edge triggered, it is no longer necessary to
> > disable interrupts in the kernel and re-enable them from user-space.
> > Instead, clearing the interrupt condition in the user space application
> > automatically re-enables the interrupt.
> > 
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > An open question is if we can just do this unconditionally
> > or if there should be some flag to enable it. A module parameter, maybe ?
> 
> NACK
> 
> UIO is for devices that don't do memory writes.
> Anything that can do writes must be protected by an IOMMU
> and/or have a secure kernel driver, not a UIO stub.
> 
> MSI is done by memory writes so if userspace
> controls the device it can trick it to write
> anywhere in memory.
> 
Interesting. Thanks for letting me know.

Guenter
