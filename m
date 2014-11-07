Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaKGGeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:34:07 -0500
Received: from gate.crashing.org ([63.228.1.57]:35942 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaKGGeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:34:05 -0500
Message-ID: <1415342031.4925.27.camel@kernel.crashing.org>
Subject: [RFC] Add of_path property for all devices with a node
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: devicetree@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Date: Fri, 07 Nov 2014 17:33:51 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey folks ! This is not (yet) a formal patch submission but...

So I've been annoyed lately with having a bunch of devices such as i2c
eeproms (for use by VPDs, server world !) and other bits and pieces that
I want to be able to identify from userspace, and possibly provide
additional data about from FW.

Basically, it boils down to correlating the sysfs device with the OF
tree device node, so that user space can use device-tree info such as
additional "location" or "label" (or whatever else we can come up with)
propreties to identify a given device, or get some attributes of use
about it, etc...

Now, so far, we've done that in some subsystem in a fairly ad-hoc basis
using "devspec" properties. For example, PCI creates them if it can
correlate the probed device with a DT node. Some powerpc specific busses
do that too.

However, i2c doesn't and it would be nice to have something more generic
since technically any device can have a corresponding device tree node.

So I came up with this patch, it seems to work well for me. I'm adding
an "of_path" attribute to not conflict with the existing "devspec" one
just for the sake of this experiment (plus "devspec" sucks). Long run,
we might want to use of_path and leave a "devspec" symlink to of_path on
the few busses that currently have devspec (pci and some powerpc
specific ones).

Comments ?

Cheers,
Ben.





