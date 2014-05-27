Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaE0UCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:02:33 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62668 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaE0UCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:02:31 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH 1/9] dt: deps: dtc: Automatically add new property
 'dependencies' which contains a list of referenced phandles
To: Alexander Holler <holler@ahsoftware.de>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <robh+dt@kernel.org>
In-Reply-To: <5379FAA5.10404@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
	<1399913280-6915-2-git-send-email-holler@ahsoftware.de>
	<53775334.3030704@gmail.com> <5379FAA5.10404@ahsoftware.de>
Date: Tue, 27 May 2014 21:02:25 +0100
Message-Id: <20140527200225.F12C4C40B4B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 14:35:49 +0200, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 17.05.2014 14:16, schrieb Tomasz Figa:
> 
> >> References to phandles of parent or child nodes will not be added to this
> >> property, because this information is already contained in the blob (in the
> >> form of the tree itself).
> >
> > I wonder if we shouldn't be including them too for consistency related
> > reasons, so we have all the necessary information in one place.
> > References to child nodes are great recipes for cycles, though...
> >
> > No strong opinion, though, just an idea.
> 
> As said, they are already in the tree itself. And they are already 
> included in the graph (these are the black edges), so they just don't 
> appear in the property dependencies.
> 
> >
> >>
> >> No dependencies to disabled nodes will be added.
> >>
> >
> > Same here. IMHO it might be wise to let the parsing entity (e.g. kernel)
> > decide whether to ignore a dependency to disabled node or not.
> >
> > Otherwise, I like the simplicity of compile-time dependency list
> > creation. Quite a nice work.
> 
> Thanks.
> 
> What's still questionable about the patches for dtc is if dependencies 
> to devices and not just drivers should be included in the new property 
> dependencies too. My current assumption is that all devices belonging to 
> one and the same driver don't have dependencies between each other. In 
> other words the order in which devices will be attached to one and the 
> same driver isn't important. If that assumption is correct it would be 
> possible to just attach all devices belonging to a driver after the 
> driver was loaded (also I haven't that done in my patches).

There aren't really any guarantees here. It is perfectly valid to have
two of the same device depending on the other, or even a device with a
different driver between the two.

There's always going to be corner cases on the dependency chain. The
question is whether or not it is worth trying to solve every concievable
order, or if a partway solution is good enough.

g.
