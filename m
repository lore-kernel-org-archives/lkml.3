Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab3K0S4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:56:42 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:37961 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab3K0S4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:56:39 -0500
Date: Wed, 27 Nov 2013 13:56:34 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-ide@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] ATA: Fix port removal ordering
Message-ID: <20131127185634.GD13098@mtj.dyndns.org>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
 <3805095.rqdZNnA0Ng@vostro.rjw.lan>
 <20131125101154.GS2281@intel.com>
 <9509557.LMLHG8ie3T@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9509557.LMLHG8ie3T@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 01:19:01PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit bcdde7e221a8 (sysfs: make __sysfs_remove_dir() recursive)
> Mika Westerberg sees traces analogous to the one below in Thunderbolt
> hot-remove testing:
...
> The source of this problem is that SCSI hosts are removed from
> ATA ports after calling ata_tport_delete() which removes the
> port's sysfs directory, among other things.  Now, after commit
> bcdde7e221a8, the sysfs directory is removed along with all of
> its subdirectories that include the SCSI host's sysfs directory
> and its subdirectories at this point.  Consequently, when
> device_del() is finally called for any child device of the SCSI
> host and tries to remove its "power" group (which is already
> gone then), it triggers the above warning.
> 
> To make the warnings go away, change the removal ordering in
> ata_port_detach() so that the SCSI host is removed from the
> port before ata_tport_delete() is called.
> 
> References: https://bugzilla.kernel.org/show_bug.cgi?id=65281
> Reported-and-tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Applied to libata/for-3.13-fixes.

Thanks!

-- 
tejun
