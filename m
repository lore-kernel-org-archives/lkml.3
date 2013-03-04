Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab3CDCzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:55:44 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45814 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab3CDCzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:55:43 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Support a PCI device that is compatible with 'simple-bus'
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <20121219191800.GA1169@obsidianresearch.com>
References: <20121210215119.GA32011@obsidianresearch.com> <20121214202629.BD40C3E0BDD@localhost> <20121214215814.GA14149@obsidianresearch.com> <20121219125451.3F1FB3E0AD7@localhost> <20121219191800.GA1169@obsidianresearch.com>
Date: Mon, 04 Mar 2013 10:55:36 +0800
Message-Id: <20130304025536.4CC7E3E17F8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 12:18:00 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> On Wed, Dec 19, 2012 at 12:54:51PM +0000, Grant Likely wrote:
> > In both cases, the type of transfer is encoded by the BAR address and
> > does not get exposed to the child device. Exposing the PCI flags into
> > the child bus(es) really isn't a very good idea because they don't make
> > sense in that context. It may seem expedient, but it will be fragile.
> 
> Well, it makes as much sense as for a PCI driver - each of the three
> transfer types has different coding requirements in the driver, so
> each of the three type must be kept separate.
> 
> I haven't looked super closely at this, but the basic desire is to
> have IORESOURCE_PREFETCH tagged on the struct resource that reaches
> the platform driver. 'get_flags' for a non-PCI addresses scheme always
> returns IORESOURCE_MEM, and translating through a ranges doesn't
> appear to fix that. This is where 3dw is desirable because it uses a
> get_flags that understands the three resource types.

We could possibly change the ranges translation code to pick up
IORESOURCE_PREFETCH when a translation crosses a PREFETCH bar. That
would also ensure that child nodes don't have to keep the flags field
consistent with the ranges mapping.

g.
