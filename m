Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3CTRqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:46:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:51217 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab3CTRqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:46:33 -0400
Message-ID: <1363801579.17680.3.camel@pasglop>
Subject: Re: [PATCH 1/2] of: Make device nodes kobjects so they show up in
 sysfs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 20 Mar 2013 18:46:19 +0100
In-Reply-To: <20130320165620.GB28307@kroah.com>
References: <1363791074-16415-1-git-send-email-grant.likely@secretlab.ca>
	 <1363791074-16415-2-git-send-email-grant.likely@secretlab.ca>
	 <1363791432.12701.8.camel@pasglop> <20130320165620.GB28307@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 09:56 -0700, Greg Kroah-Hartman wrote:
> > Unfortunately they occasionally are... VPDs can be pretty big for
> > example.
> 
> If the attributes are binary blobs, use the binary file capability of
> sysfs to properly handle them.

Except that we don't know that ... we have properties which comes all as
"blobs", only the consumers can interpret what they contain. Tools like
lsprop or dtc do have some built-in smarts to differentiate for example
strings, simple numbers and blobs based roughly on heuristics of content
& size but that's purely for the sake of pretty printing.

Something like /proc/device-tree (or a sysfs equivalent) has no way
really to know what's in there. So basically they should *all* be binary
blobs.

> > > Second, all normal sysfs attributes report their size as 4096 bytes
> > > instead of the actual property size reported in /proc/device-tree. It is
> > > possible that this change will cause some userspace tools to break.
> > 
> > This is btw a complete idiocy of sysfs and should/could be fixed.
> 
> How can sysfs change this?  It doesn't know the size of the attribute
> ahead of time, and it can change depending on what happens in the
> system.  So we default to a page size, which is the largest size an
> attribute can be.

That's true for some attributes I suppose and I while I do understand
the difficulty there would be in calculating all the sizes on every
stat, it's still gross, especially for those plenty of attributes who
do have a fixed size.

In our case, we do know the size, we should expose it.

Cheers,
Ben.


