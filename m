Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaI3Kz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:55:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaI3KzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:55:24 -0400
Date: Tue, 30 Sep 2014 12:55:20 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [PATCH v2] i2c: move acpi code back into the core
Message-ID: <20140930125520.61b57882@endymion.delvare>
In-Reply-To: <1411594591-5048-1-git-send-email-wsa@the-dreams.de>
References: <1411594591-5048-1-git-send-email-wsa@the-dreams.de>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Sorry for the late reply, I was on the road for most of the past 2
weeks.

On Wed, 24 Sep 2014 23:36:31 +0200, Wolfram Sang wrote:
> Commit 5d98e61d337c ("I2C/ACPI: Add i2c ACPI operation region support")
> renamed the i2c-core module. This may cause regressions for
> distributions, so put the ACPI code back into the core.
> 
> Reported-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: Lan Tianyu <tianyu.lan@intel.com>
> Cc: Jean Delvare <jdelvare@suse.de>
> ---
> 
> v2: - make all acpi functions static
>     - annotate #endif
>     - remove declarations in i2c.h
>     - add dummy functions to i2c-core.c
>     - make two seperate #ifdef blocks instead of two nested ones
>       (otherwise build errors due to no external decl. anymore)
> 
> Mika, Lan, Jean: please test/review. I am still waiting for some testbot
> results, yet your audit is very wanted.

I see that the patch is already upstream. Nevertheless I reviewed the
integration part of it and it looks OK to me. Thanks for doing that!

The only thing which I find curious is that ACPI_I2C_OPREGION depends
on I2C=y. Is this limitation a leftover from when the code was split to
a separate file? It builds just fine with I2C=m, and I can't see why it
wouldn't work. I have a patch to enable that, I can send it if it is
the right thing to do. But maybe I'm missing something?

Thanks again,
-- 
Jean Delvare
SUSE L3 Support
