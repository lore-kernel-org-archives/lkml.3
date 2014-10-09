Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaJIIGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:06:13 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37130 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJIIGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:06:04 -0400
MIME-Version: 1.0
In-Reply-To: <20141009080016.GA1203@ulmo>
References: <1412835112-7209-1-git-send-email-acourbot@nvidia.com>
 <20141009074326.GA1010@ulmo> <54363DE8.9030102@nvidia.com> <20141009080016.GA1203@ulmo>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 9 Oct 2014 17:05:44 +0900
Message-ID: <CAAVeFuLwE5L1y1syGZySB1G2XfS_-ZmNWscr01Y4jA+0d_rQKA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: tegra: venice2: add GK20A GPU DT node
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 5:00 PM, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Thu, Oct 09, 2014 at 04:48:56PM +0900, Alexandre Courbot wrote:
>> On 10/09/2014 04:43 PM, Thierry Reding wrote:
>> >* PGP Signed by an unknown key
>> >
>> >On Thu, Oct 09, 2014 at 03:11:51PM +0900, Alexandre Courbot wrote:
>> >>From: Thierry Reding <treding@nvidia.com>
>> >>
>> >>Add the device-tree node for the GK20A GPU and leave it disabled by
>> >>default. It is the responsability of the bootloader to enable it if the
>> >>VPR registers have been programmed such as the GPU can operate.
>> >>
>> >>Signed-off-by: Thierry Reding <treding@nvidia.com>
>> >>Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> >>---
>> >>  arch/arm/boot/dts/tegra124-venice2.dts | 8 +++++++-
>> >>  1 file changed, 7 insertions(+), 1 deletion(-)
>> >
>> >Are you going to send the corresponding patches for U-Boot to update
>> >the status property if it's initialized VPR?
>>
>> Yes. But maybe I should wait until upstream Nouveau actually works properly
>> for that? Right now it will probe successfully, but will crash as soon as
>> the GPU is used because there still are memory coherency problems.
>
> I think the same really goes for these patches. Applying these will make
> the node available to U-Boot, so technically some future U-Boot version
> could modify a kernel DTB and boot a version where nouveau didn't yet
> work out-of-the-box.
>
> There's also still the issue about firmware loading and so on, so maybe
> holding off on applying these patches until gk20a is fully enabled is a
> good idea. Normally I guess this would be done by not adding the kernel
> driver until it's expected to be at least usable to some degree, but I
> guess it is a bit late for that now.

I'm fine with that too. Dropping these patches fow now.
