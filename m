Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3C1SBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:01:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35615 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3C1SBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:01:01 -0400
Message-ID: <51548559.6030605@wwwdotorg.org>
Date: Thu, 28 Mar 2013 12:00:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, Grant Likely <glikely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
CC: arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH REPOST 2/7] kbuild: fixdep: support concatenated dep files
References: <1363890194-31538-1-git-send-email-swarren@wwwdotorg.org> <1363890194-31538-2-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1363890194-31538-2-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 12:23 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> The current use-case for fixdep is: a source file is run through a single
> processing step, which creates a single dependency file as a side-effect,
> which fixdep transforms into the file used by the kernel build process.
> 
> In order to transparently run the C pre-processor on device-tree files,
> we wish to run both gcc -E and dtc on a source file in a single rule.
> This generates two dependency files, which must be transformed together
> into the file used by the kernel build process. This change modifies
> fixdep so it can process the concatenation of multiple separate input
> dependency files, and produce a correct unified output.
> 
> The code changes have the slight benefit of transforming the loop in
> parse_dep_file() into more of a lexer/tokenizer, with the loop body being
> more of a parser. Previously, some of this logic was mixed together
> before the loop. I also added some comments, which I hope are useful.
> 
> Benchmarking shows that on a cross-compiled ARM tegra_defconfig build,
> there is less than 0.5 seconds speed decrease with this change, on top
> of a build time of ~2m24s. This is probably within the noise.

Marek, do patches 2, 3, and 4 in this series look good to you from a
kbuild perspective?

I'm hoping that you can review/ack those 3 patches for kbuild, and that
Grant will review/ack the whole series, and then the series can be
merged via arm-soc for 3.10.

Let me know if you need me to repost the series again in case it's
fallen out of your inbox.

Thanks.
