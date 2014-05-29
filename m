Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbaE2TEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:04:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47514 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaE2TEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:04:36 -0400
Message-ID: <538784C1.6000504@wwwdotorg.org>
Date: Thu, 29 May 2014 13:04:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/5] misc: fuse: Add efuse driver for Tegra
References: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com> <1401281677-32110-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1401281677-32110-4-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 06:54 AM, Peter De Schrijver wrote:
> Implement fuse driver for Tegra20, Tegra30, Tegra114 and Tegra124.

> diff --git a/Documentation/ABI/testing/sysfs-driver-tegra-fuse b/Documentation/ABI/testing/sysfs-driver-tegra-fuse

> +Description:	read-only access to the efuses on Tegra20, Tegra30, Tegra114
> +		and Tegra124 SoC's from NVIDIA. The efuses contain write once
> +		data programmed at the factory. The data is layed out in 32bit
> +		words in LSB first formnat. The number of valid bits depends

s/formnat/format/

> +		on the word and the SoC. The mapping is as follows:
> +
> +		For Tegra20:
> +		Word 0 - 1    : bit 0
> +		Word 2        : unused
> +		Word 3        : bits 0 - 31
> +		Word 4        : bits 0 - 7

Do we really need these long tables that indicate which bits are used?
As I mentioned before, when I asked for documentation of the format of
these files, all I wanted was a brief not indicating that the data was
binary, and that each bit potentially represents a fuse... Either we
should leave it at that, or actually document what each bit represents,
which would hopefully be a pointless duplication of the TRM.
