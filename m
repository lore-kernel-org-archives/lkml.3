Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab3GIQgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:36:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42753 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197Ab3GIQgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:36:31 -0400
X-Sasl-enc: 4JuyBXDTt+gSDQJfGi2MP2MhsXTNIrsjyocRhILf6RSL 1373387789
Date: Tue, 9 Jul 2013 09:37:26 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, joe.lawrence@stratus.com,
        myron.stowe@redhat.com, bhelgaas@google.com
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
Message-ID: <20130709163726.GA11809@kroah.com>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
 <20130709041321.GA30555@kroah.com>
 <20130709094906.GA3870@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709094906.GA3870@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 11:49:06AM +0200, Pavel Machek wrote:
> On Mon 2013-07-08 21:13:21, Greg KH wrote:
> > On Tue, Jul 09, 2013 at 03:26:11AM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > My thinkpad has rather high ping latencies... and perhaps it is due to
> > > PCIE ASPM.
> > 
> > Why would that be the problem?  The odds that the PCIE bus is the issue
> > seems strange to me.
> 
> Aha: I guess that's why the file is not writable:
> 
> pavel@amd:~$ dmesg | grep -i aspm 
> ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> e1000e 0000:02:00.0: Disabling ASPM L0s L1
> pavel@amd:~$ cat /sys/module/pcie_aspm/parameters/policy
> [default] performance powersave 
> pavel@amd:~$ 
> root@amd:~# echo -n performance >
> /sys/module/pcie_aspm/parameters/policy
> -su: echo: write error: Operation not permitted
> root@amd:~# 
> 
> But:
> 1) it should not list unavailable options

It's a module parameter, you can't control if they are present or not
dynamically.

> 2) operation not permitted seems like wrong error code for
> operation not supported.

Then what should it be?

greg k-h
