Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab3EHPAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:00:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58022 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab3EHPAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:00:14 -0400
Message-ID: <518A6649.1020501@wwwdotorg.org>
Date: Wed, 08 May 2013 08:50:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matthijs Kooijman <matthijs@stdin.nl>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] kbuild: Don't assume dts files live in arch/*/boot/dts
References: <1368010744-11281-1-git-send-email-matthijs@stdin.nl>
In-Reply-To: <1368010744-11281-1-git-send-email-matthijs@stdin.nl>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 04:59 AM, Matthijs Kooijman wrote:
> In commit b40b25ff (kbuild: always run gcc -E on *.dts, remove cmd_dtc_cpp),
> dts building was changed to always use the C preprocessor. This meant
> that the .dts file passed to dtc is not the original, but the
> preprocessed one.
> 
> When compiling with a separate build directory (i.e., with O=), this
> preprocessed file will not live in the same directory as the original.
> When the .dts file includes .dtsi files, dtc will look for them in the
> build directory, not in the source directory and compilation will fail.
> 
> The commit referenced above tried to fix this by passing arch/*/boot/dts
> as an include path to dtc. However, for mips, the .dts files are not in
> this directory, so dts compilation on mips breaks for some targets.
> 
> Instead of hardcoding this particular include path, this commit just
> uses the directory of the .dts file that is being compiled, which
> effectively restores the previous behaviour wrt includes. For most .dts
> files, this path is just the same as the previous hardcoded
> arch/*/boot/dts path.
> 
> This was tested on a mips (rt3052) and an arm (bcm2835) target.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

(although I wonder if the .dts files shouldn't be in a standard location?)
