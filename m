Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaBLSUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:20:09 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:59015 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbaBLSUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:20:06 -0500
Date: Wed, 12 Feb 2014 11:20:00 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Arnd Bergmann <arnd@arndb.de>, keescook@chromium.org,
        devicetree@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
Message-ID: <20140212182000.GJ5554@obsidianresearch.com>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
 <201402121251.06280.arnd@arndb.de>
 <20140212174554.GM27395@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212174554.GM27395@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 12:45:54PM -0500, Jason Cooper wrote:

> The bootloader would then load this file into ram, and pass the
> address/size to the kernel either via dt, or commandline.  kaslr (run in
> the decompressor) would consume some of this randomness, and then
> random.c would consume the rest in a non-crediting initialization.

Sure is a neat idea, but I think in general it would probably be smart
to include the entire FDT blob in the early random pool, that way you
get MACs and other machine unique data too.

>From there it is a small step to encourage bootloaders to include
boot-time-variable data in the DT like like 'boot time of day', 'cycle
counter', 'random blob', etc.

Then you just need the bootloader to dump the random-seed file into a
DT property.

Or have the bootloader fetch randomness from any HWRNG it has a driver
for. (eg a TPM)

Jason
