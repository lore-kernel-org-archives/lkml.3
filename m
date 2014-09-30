Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaI3SqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:46:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbaI3SqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:46:11 -0400
Date: Tue, 30 Sep 2014 20:46:07 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [PATCH v2] i2c: move acpi code back into the core
Message-ID: <20140930204607.2ab3baed@endymion.delvare>
In-Reply-To: <20140930160352.GV1786@lahna.fi.intel.com>
References: <1411594591-5048-1-git-send-email-wsa@the-dreams.de>
	<20140930125520.61b57882@endymion.delvare>
	<20140930160352.GV1786@lahna.fi.intel.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014 19:03:52 +0300, Mika Westerberg wrote:
> On Tue, Sep 30, 2014 at 12:55:20PM +0200, Jean Delvare wrote:
> > The only thing which I find curious is that ACPI_I2C_OPREGION depends
> > on I2C=y. Is this limitation a leftover from when the code was split to
> > a separate file? It builds just fine with I2C=m, and I can't see why it
> > wouldn't work. I have a patch to enable that, I can send it if it is
> > the right thing to do. But maybe I'm missing something?
> 
> I think reason for the limitation is that if there happens to be some
> AML code that is currently using the I2C operation region and the user
> decides to unload the i2c-core.ko module or along those lines.

If that's the reason then shouldn't it be addressed by proper reference
counting instead? We could simply increase the module reference count
when entering the critical section, and decrease it when we're done.

-- 
Jean Delvare
SUSE L3 Support
