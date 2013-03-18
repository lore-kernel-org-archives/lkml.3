Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3CRPrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:47:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58575 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3CRPrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:47:31 -0400
Message-ID: <5147370F.9030500@wwwdotorg.org>
Date: Mon, 18 Mar 2013 09:47:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: arm@kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 1/7] kbuild: create an "include chroot" for DT bindings
References: <1362594183-21523-1-git-send-email-swarren@wwwdotorg.org> <20130318151348.GB4713@S2101-09.ap.freescale.net>
In-Reply-To: <20130318151348.GB4713@S2101-09.ap.freescale.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 09:13 AM, Shawn Guo wrote:
> On Wed, Mar 06, 2013 at 11:22:57AM -0700, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> The recent dtc+cpp support allows header files and C pre-processor
>> defines/macros to be used when compiling device tree files. These
>> headers will typically define various constants that are part of the
>> device tree bindings.
>>
>> The original patch which set up the dtc+cpp include path only considered
>> using those headers from device tree files. However, most are also
>> useful for kernel code which needs to interpret the device tree.
>>
>> In both the DT files and the kernel, I'd like to include the DT-related
>> headers in the same way, for example, <dt-bindings/gpio/tegra-gpio.h>.
>> That will simplify any text which discusses the DT header locations.
>>
>> Creating a <dt-bindings/> for kernel source to use is as simple as
>> placing files into include/dt-bindings/.
>>
>> However, when compiling DT files, the include path should be restricted
>> so that only the dt-bindings path is available; arbitrary kernel headers
>> shouldn't be exposed. For this reason, create a specific include
>> directory for use by dtc+cpp, and symlink dt-bindings from there to the
>> actual location of include/dt-bindings/. For want of a better location,
>> place this "include chroot" into the existing dts/ directory.
>>
>> arch/*/boot/dts/include/dt-bindings -> ../../../../../include/dt-bindings
>>
>> Some headers used by device tree files may not be useful to the kernel;
>> they may be used simply to aid in constructing the DT file (e.g. macros
>> to create a node), but not define any information that the kernel needs
>> to share. These may be placed directly into arch/*/boot/dts/ along with
>> the DT files themselves.
>>
>> Cc: Shawn Guo <shawn.guo@linaro.org>
>> Cc: Hiroshi Doyu <hdoyu@nvidia.com>
>> Acked-by: Michal Marek <mmarek@suse.cz>
>> Acked-by: Shawn Guo <shawn.guo@linaro.org>
>> Acked-by: Rob Herring <rob.herring@calxeda.com>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> This first patch was previously posted separately as V2. I'm including
>> it here to keep it with the whole series. I hope this series can be
>> applied as a topic branch in arm-soc.
> 
> So no comments on the series means that we can start maintain it on
> a topic branch, so that people can base their works on it?

I was thinking of reposting the series today due to lack of responses,
so that the content was freshly available in people's inboxes.
