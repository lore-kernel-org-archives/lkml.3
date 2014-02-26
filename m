Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaBZXsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:48:21 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38087 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaBZXsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:48:18 -0500
MIME-Version: 1.0
In-Reply-To: <20140226224844.219fe0ac@alan.etchedpixels.co.uk>
References: <20140226190306.9616.30567.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140226190927.9616.43043.stgit@bhelgaas-glaptop.roam.corp.google.com> <20140226224844.219fe0ac@alan.etchedpixels.co.uk>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Feb 2014 16:47:58 -0700
Message-ID: <CAErSpo7=vbbNck6Ua+-5ycHVCuby0OnxHMGmhSw3Qb-iXOsaeA@mail.gmail.com>
Subject: Re: [PATCH 4/4] i2o: Use pci_bus_alloc_resource(), not
 allocate_resource() directly
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Markus Lidel <Markus.Lidel@shadowconnect.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 3:48 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Wed, 26 Feb 2014 12:09:27 -0700
> Bjorn Helgaas <bhelgaas@google.com> wrote:
>
>> Convert i2o_res_alloc() to use pci_bus_alloc_resource() rather than
>> pci_find_parent_resource() and allocate_resource().  We don't have a
>> resource to start with, so pci_find_parent_resource() can't do anything
>> useful: a bus may have several memory resources available, so there might
>> be several possible parents.  This is more likely on root buses because
>> host bridges may have any number of apertures.
>>
>> I'm pretty sure this didn't work in the first place because it passed
>> size == min == max to allocate_resource().  The min and max parameters are
>> constraints on the *addresses* of the resource, not on its size, so I think
>> it was impossible for allocate_resource() to succeed.
>
> I don't think many i2o controllers ever used that path, and I doubt any
> in normal use did as the vision of offloading for devices on the host bus
> basically never happened (it happened even less than i2o)
>
> A rather more sensible question might be "If i2o went away is there
> anyone who would even notice". About the only devices that ever used i2o
> in the real world (AMI MegaRAID and some FC stuff) had native firmware or
> modes that worked better anyway.

I don't know anything about i2o, so I have no idea whether it could be
completely removed.  I just want to remove its usage of
pci_find_parent_resource() so I can change the semantics of that a bit
(see [1]).

Bjorn

[1] https://lkml.kernel.org/r/20140226193723.10125.15799.stgit@bhelgaas-glaptop.roam.corp.google.com
