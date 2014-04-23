Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbaDWHWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:22:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:59698 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbaDWHWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:22:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="497886559"
Date: Wed, 23 Apr 2014 10:28:39 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, rjw@rjwysocki.net, awilliam@redhat.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Resend Patch 7/9] I2C/ACPI: Add i2c ACPI operation region
 support
Message-ID: <20140423072839.GT30677@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-8-git-send-email-tianyu.lan@intel.com>
 <20140422113638.GK30677@intel.com>
 <53571D11.3070808@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53571D11.3070808@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 09:53:21AM +0800, Lan Tianyu wrote:
> Hi Mika:
> 	Thanks a lot for your review.
> 
> On 2014年04月22日 19:36, Mika Westerberg wrote:
> >> > +
> >> > +	client.adapter = adapter;
> >> > +	client.addr = sb->slave_address;
> >> > +	client.flags = 0;
> > I'm not sure if this is the correct way to use struct i2c_client
> > (allocating it from stack and passing forward to functions that might
> > expect a real i2c_client structure). It has ->dev and all.
> 
> I check all i2c_smbus_xxx helper functions and they are simple wrappers
> of i2c_smbus_xfer(). Only adapter, addr and flags of struct client are
> used in these functions.

In that case I suppose it is OK to (ab)use the client structure like this.

I think you still want to initialize the whole structure (unused fields
with zero) before passing it to the wrappers.
