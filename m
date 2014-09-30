Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaI3QEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:04:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:30375 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaI3QEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:04:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,627,1406617200"; 
   d="scan'208";a="610979018"
Date: Tue, 30 Sep 2014 19:03:52 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [PATCH v2] i2c: move acpi code back into the core
Message-ID: <20140930160352.GV1786@lahna.fi.intel.com>
References: <1411594591-5048-1-git-send-email-wsa@the-dreams.de>
 <20140930125520.61b57882@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930125520.61b57882@endymion.delvare>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:55:20PM +0200, Jean Delvare wrote:
> The only thing which I find curious is that ACPI_I2C_OPREGION depends
> on I2C=y. Is this limitation a leftover from when the code was split to
> a separate file? It builds just fine with I2C=m, and I can't see why it
> wouldn't work. I have a patch to enable that, I can send it if it is
> the right thing to do. But maybe I'm missing something?

I think reason for the limitation is that if there happens to be some
AML code that is currently using the I2C operation region and the user
decides to unload the i2c-core.ko module or along those lines.
