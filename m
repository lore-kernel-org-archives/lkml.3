Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3CFQOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:14:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44776 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3CFQOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:14:43 -0500
Message-ID: <51376B6E.2060806@wwwdotorg.org>
Date: Wed, 06 Mar 2013 09:14:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hiroshi Doyu <hdoyu@nvidia.com>,
        "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCH V2 REPOST] kbuild: create an "include chroot" for DT bindings
References: <1362506797-21905-1-git-send-email-swarren@wwwdotorg.org> <5136E866.20008@gmail.com>
In-Reply-To: <5136E866.20008@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 11:55 PM, Rob Herring wrote:
> On 03/05/2013 12:06 PM, Stephen Warren wrote:
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
>> Cc: Hiroshi Doyu <hdoyu@nvidia.com>
>> Acked-by: Michal Marek <mmarek@suse.cz>
>> Acked-by: Shawn Guo <shawn.guo@linaro.org>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> Grant, Rob,
>>
>> This is a pre-requisite for people to convert their *.dts files to use
>> cpp, and hence is likely to be useful for a number of ARM subarch trees.
>> Perhaps this patch can be placed into a standalone topic branch in the
>> DT repo so we can all merge it. Assuming this patch is OK, I would also
>> repost the patches that create common headers defining IRQ, and GPIO
>> flags, which would place files into the new include/dt-bindings
>> directory.
> 
> This looks fine to me. As all these will all be arm-soc branches with
> the dependency, it probably makes more sense for Arnd/Olof to apply this
> and create the branch for this single patch.

OK, that'd work fine for me too. I expect that arm-soc branch would also
include the few patches to create some common headers, once I repost.


