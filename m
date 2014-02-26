Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaBZWtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:49:05 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43395 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaBZWsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:48:54 -0500
Date: Wed, 26 Feb 2014 22:48:44 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, Markus Lidel <Markus.Lidel@shadowconnect.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] i2o: Use pci_bus_alloc_resource(), not
 allocate_resource() directly
Message-ID: <20140226224844.219fe0ac@alan.etchedpixels.co.uk>
In-Reply-To: <20140226190927.9616.43043.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226190306.9616.30567.stgit@bhelgaas-glaptop.roam.corp.google.com>
	<20140226190927.9616.43043.stgit@bhelgaas-glaptop.roam.corp.google.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 12:09:27 -0700
Bjorn Helgaas <bhelgaas@google.com> wrote:

> Convert i2o_res_alloc() to use pci_bus_alloc_resource() rather than
> pci_find_parent_resource() and allocate_resource().  We don't have a
> resource to start with, so pci_find_parent_resource() can't do anything
> useful: a bus may have several memory resources available, so there might
> be several possible parents.  This is more likely on root buses because
> host bridges may have any number of apertures.
> 
> I'm pretty sure this didn't work in the first place because it passed
> size == min == max to allocate_resource().  The min and max parameters are
> constraints on the *addresses* of the resource, not on its size, so I think
> it was impossible for allocate_resource() to succeed.

I don't think many i2o controllers ever used that path, and I doubt any
in normal use did as the vision of offloading for devices on the host bus
basically never happened (it happened even less than i2o)

A rather more sensible question might be "If i2o went away is there
anyone who would even notice". About the only devices that ever used i2o
in the real world (AMI MegaRAID and some FC stuff) had native firmware or
modes that worked better anyway.

Alan
