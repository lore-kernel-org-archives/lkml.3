Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaKME3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 23:29:04 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:39276 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaKME27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 23:28:59 -0500
Message-ID: <54643384.5030309@gmail.com>
Date: Wed, 12 Nov 2014 20:28:52 -0800
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] Add of_path property for all devices with a node
References: <1415342031.4925.27.camel@kernel.crashing.org>
In-Reply-To: <1415342031.4925.27.camel@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/2014 10:33 PM, Benjamin Herrenschmidt wrote:
> Hey folks ! This is not (yet) a formal patch submission but...
> 
> So I've been annoyed lately with having a bunch of devices such as i2c
> eeproms (for use by VPDs, server world !) and other bits and pieces that
> I want to be able to identify from userspace, and possibly provide
> additional data about from FW.
> 
> Basically, it boils down to correlating the sysfs device with the OF
> tree device node, so that user space can use device-tree info such as
> additional "location" or "label" (or whatever else we can come up with)
> propreties to identify a given device, or get some attributes of use
> about it, etc...
> 
> Now, so far, we've done that in some subsystem in a fairly ad-hoc basis
> using "devspec" properties. For example, PCI creates them if it can
> correlate the probed device with a DT node. Some powerpc specific busses
> do that too.
> 
> However, i2c doesn't and it would be nice to have something more generic
> since technically any device can have a corresponding device tree node.
> 
> So I came up with this patch, it seems to work well for me. I'm adding
> an "of_path" attribute to not conflict with the existing "devspec" one
> just for the sake of this experiment (plus "devspec" sucks). Long run,
> we might want to use of_path and leave a "devspec" symlink to of_path on
> the few busses that currently have devspec (pci and some powerpc
> specific ones).
> 
> Comments ?
> 
> Cheers,
> Ben.

If I understand correctly, that information is already available in
the file uevent.  For example, if I apply your patch, at least
for a simple path, I see the same path name in uevent as in of_path:

   $ cd /sys/devices/soc/f9824900.sdhci
   $ cat of_path
   /soc/sdhci@f9824900
   $ grep OF_FULLNAME uevent | cut -d"=" -f2
   /soc/sdhci@f9824900

-Frank
