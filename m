Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161975Ab3DEQGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:06:39 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:58281 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161930Ab3DEQGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:06:36 -0400
Message-ID: <515EF68A.3020505@gmail.com>
Date: Fri, 05 Apr 2013 11:06:34 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <glikely@secretlab.ca>,
        arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 1/7] kbuild: create an "include chroot" for DT bindings
References: <1365032098-22825-1-git-send-email-swarren@wwwdotorg.org> <515E09FA.1090408@gmail.com> <515E2257.4030607@wwwdotorg.org>
In-Reply-To: <515E2257.4030607@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 08:01 PM, Stephen Warren wrote:
> On 04/04/2013 05:17 PM, Rob Herring wrote:
>> On 04/03/2013 06:34 PM, Stephen Warren wrote:
>>> From: Stephen Warren <swarren@nvidia.com>
>>>
>>> The recent dtc+cpp support allows header files and C pre-processor
>>> defines/macros to be used when compiling device tree files. These
>>> headers will typically define various constants that are part of the
>>> device tree bindings.
>>>
>>> The original patch which set up the dtc+cpp include path only considered
>>> using those headers from device tree files. However, most are also
>>> useful for kernel code which needs to interpret the device tree.
>>>
>>> In both the DT files and the kernel, I'd like to include the DT-related
>>> headers in the same way, for example, <dt-bindings/gpio/tegra-gpio.h>.
>>> That will simplify any text which discusses the DT header locations.
>>>
>>> Creating a <dt-bindings/> for kernel source to use is as simple as
>>> placing files into include/dt-bindings/.
>>>
>>> However, when compiling DT files, the include path should be restricted
>>> so that only the dt-bindings path is available; arbitrary kernel headers
>>> shouldn't be exposed. For this reason, create a specific include
>>> directory for use by dtc+cpp, and symlink dt-bindings from there to the
>>> actual location of include/dt-bindings/. For want of a better location,
>>> place this "include chroot" into the existing dts/ directory.
>>>
>>> arch/*/boot/dts/include/dt-bindings -> ../../../../../include/dt-bindings
>>>
>>> Some headers used by device tree files may not be useful to the kernel;
>>> they may be used simply to aid in constructing the DT file (e.g. macros
>>> to create a node), but not define any information that the kernel needs
>>> to share. These may be placed directly into arch/*/boot/dts/ along with
>>> the DT files themselves.
>>>
>>> Cc: Shawn Guo <shawn.guo@linaro.org>
>>> Cc: Hiroshi Doyu <hdoyu@nvidia.com>
>>> Acked-by: Michal Marek <mmarek@suse.cz>
>>> Acked-by: Shawn Guo <shawn.guo@linaro.org>
>>> Acked-by: Rob Herring <rob.herring@calxeda.com>
>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>> ---
>>> Grant, Rob, Michal, I'm hoping for acks or comments from you so this
>>> series can be placed into a topic branch in the arm-soc repo, for others
>>> to build on during the 3.10 kernel cycle. Thanks.
>>
>> Well, you have mine here and the rest looks fine, so add it to the others.
> 
> Rob,
> 
> I had originally hoped for this to go into an arm-soc branch so that a
> number of SoCs could convert to use the feature in the same release,
> hence I was looking for acks to let that happen.
> 
> However, it's too late in the 3.10 cycle now for that to happen. Can the
> series be applied to the DT tree instead; people can convert during the
> 3.11 cycle.

That is fine. Can you send me a pull request.

Rob


