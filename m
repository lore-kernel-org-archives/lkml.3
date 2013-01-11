Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3AKSZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:25:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:57289 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab3AKSZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:25:49 -0500
Date: Fri, 11 Jan 2013 10:25:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, dwmw2@infradead.org,
        jeffrey.t.kirsher@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ixgbe: request_firmware for configuration parameters
Message-ID: <20130111182547.GA22231@kroah.com>
References: <20130111020046.15463.72333.stgit@starfish.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130111020046.15463.72333.stgit@starfish.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 06:02:20PM -0800, Shannon Nelson wrote:
> Most networking dials and knobs can be set using ethtool, ifconfig, ip link
> commands, or sysfs entries, all of which can be driven by startup scripts
> and other configuration tools.  However, they all depend on having a netdev
> already set up, and we have some low-level device functionality that needs
> to be sorted out before we start setting up MSI-x and memory allocations.
> 
> In order to do early device configuration, most kernel drivers use module
> parameters whose settings can be persisted in modprobe.d config files.
> However, these can be clumsy to use and manage, difficult to specify port
> specific values in a multiport device, and are actively discouraged in
> some circles.
> 
> In this patchset, the driver uses the existing request_firmware() and
> match_token() facilities to grab an ASCII config file from userspace to
> find special startup-time configuration information that needs persistence
> across reboots.  The configuration strings are formed similar to the
> mount options that get passed from /etc/fstab into filesystem modules.

Ick, please don't abuse request_firmware() for this type of thing.

What's wrong with configfs?  It sounds like it will fit your need, and
that is what is created for.

greg k-h
