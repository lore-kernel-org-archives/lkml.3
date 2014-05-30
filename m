Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbaE3LgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:36:24 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12550 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaE3LgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:36:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 30 May 2014 04:29:09 -0700
Date: Fri, 30 May 2014 14:36:18 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/5] misc: fuse: Add efuse driver for Tegra
Message-ID: <20140530113618.GQ5961@tbergstrom-lnx.Nvidia.com>
References: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com>
 <1401281677-32110-4-git-send-email-pdeschrijver@nvidia.com>
 <538784C1.6000504@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <538784C1.6000504@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 09:04:33PM +0200, Stephen Warren wrote:
> On 05/28/2014 06:54 AM, Peter De Schrijver wrote:
> > Implement fuse driver for Tegra20, Tegra30, Tegra114 and Tegra124.
> 
> > diff --git a/Documentation/ABI/testing/sysfs-driver-tegra-fuse b/Documentation/ABI/testing/sysfs-driver-tegra-fuse
> 
> > +Description:	read-only access to the efuses on Tegra20, Tegra30, Tegra114
> > +		and Tegra124 SoC's from NVIDIA. The efuses contain write once
> > +		data programmed at the factory. The data is layed out in 32bit
> > +		words in LSB first formnat. The number of valid bits depends
> 
> s/formnat/format/
> 
> > +		on the word and the SoC. The mapping is as follows:
> > +
> > +		For Tegra20:
> > +		Word 0 - 1    : bit 0
> > +		Word 2        : unused
> > +		Word 3        : bits 0 - 31
> > +		Word 4        : bits 0 - 7
> 
> Do we really need these long tables that indicate which bits are used?
> As I mentioned before, when I asked for documentation of the format of
> these files, all I wanted was a brief not indicating that the data was
> binary, and that each bit potentially represents a fuse... Either we
> should leave it at that, or actually document what each bit represents,
> which would hopefully be a pointless duplication of the TRM.

Some fuses are OEM defined, so there is no way to document all fuses there.
Would you be ok with just dropping the tables then? So, the description would
become:

Description:    read-only access to the efuses on Tegra20, Tegra30, Tegra114
                and Tegra124 SoC's from NVIDIA. The efuses contain write once
                data programmed at the factory. The data is layed out in 32bit
                words in LSB first format. The number of valid bits depends
                on the word and the SoC.

Cheers,

Peter.

