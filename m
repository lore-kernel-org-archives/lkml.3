Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab3IBKuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:50:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:11694 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972Ab3IBKus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:50:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1006,1367996400"; 
   d="scan'208";a="354796748"
Date: Mon, 2 Sep 2013 13:56:15 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 1/2] i2c: prepare runtime PM support for I2C client
 devices
Message-ID: <20130902105615.GR7393@intel.com>
References: <1377007416-13851-1-git-send-email-mika.westerberg@linux.intel.com>
 <1377007416-13851-2-git-send-email-mika.westerberg@linux.intel.com>
 <20130828093858.GF4086@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828093858.GF4086@katana>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:38:58AM +0200, Wolfram Sang wrote:
> On Tue, Aug 20, 2013 at 05:03:35PM +0300, Mika Westerberg wrote:
> > From: Aaron Lu <aaron.lu@intel.com>
> > 
> > This patch adds runtime PM support for the I2C bus in a similar way that
> > has been done for PCI bus already. This means that the I2C bus core
> > prepares runtime PM for a client device just before a driver is about to be
> > bound to it. Devices that are not bound to any driver are not prepared for
> > runtime PM.
> > 
> > In order to take advantage of this runtime PM support, the client device
> > driver needs drop the device runtime PM reference count by calling
> > pm_runtime_put() in its ->probe() callback and possibly implement rest of
> > the runtime PM callbacks.
> > 
> > However, this does not yet make runtime PM happen for the device, it has to
> > be explicitly allowed from userspace per each I2C client device. The
> > reason for this is that things like HID over I2C might not work as smoothly
> > when runtime PM is active. So we leave it to the user to balance between
> > performance and power efficiency.
> > 
> > User can allow runtime PM for the client device by running:
> > 
> > 	# echo auto > /sys/bus/i2c/devices/<device>/power/control
> > 
> > and it can be forbidden again by:
> > 
> > 	# echo on > /sys/bus/i2c/devices/<device>/power/control
> > 
> > Status of the device can be monitored by reading files under the device
> > power directory.
> > 
> > If the driver doesn't support runtime PM (like most of the existing I2C
> > client drivers), the device in question is regarded as being runtime PM
> > active and powered on.
> > 
> > The patch adds also runtime PM support for the adapter device because it is
> > needed to be able to runtime power manage the I2C controller device. The
> > adapter device is handled along with the I2C controller device (it uses
> > pm_runtime_no_callbacks()).
> > 
> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> CCing ALKML. Would appreciate comments/tags from the runtime-PM users of
> the ARM world.

Any comments on this?

I can resend the whole series with ALKML included if that helps.
