Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3LSWea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:34:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3LSWe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:34:29 -0500
Date: Thu, 19 Dec 2013 14:34:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Levente Kurusa <levex@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Murray <amurray@embedded-bits.co.uk>,
        Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 32/38] pcie: add missing put_device call
Message-ID: <20131219223432.GA3145@kroah.com>
References: <1387465612-3673-33-git-send-email-levex@linux.com>
 <20131219221019.GB15201@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219221019.GB15201@google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 03:10:19PM -0700, Bjorn Helgaas wrote:
> [+cc Greg, Yinghai]
> 
> On Thu, Dec 19, 2013 at 04:06:46PM +0100, Levente Kurusa wrote:
> > This is required so that we give up the last reference to the device.
> > Removed the kfree() as put_device will result in release_pcie_device being
> > called and hence the container of the device will be kfree'd.
> > 
> > Signed-off-by: Levente Kurusa <levex@linux.com>
> 
> Thanks, I applied a slightly modified version of this to my pci/deletion
> branch for v3.14.
> 
> I think the get_device() after device_register() succeeds and the
> put_device() before device_unregister() are superfluous, so I propose the
> series included below.  Any comments?

Looks good to me.

greg k-h
