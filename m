Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaIYSGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:06:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33614 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbaIYSGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:06:37 -0400
Message-ID: <542459C5.9060505@wwwdotorg.org>
Date: Thu, 25 Sep 2014 12:07:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Sjoerd Simons <sjoerd@luon.net>, Alexandre Courbot <acourbot@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [5/5] ARM: tegra: jetson-tk1: enable GK20A GPU
References: <1400491450-19223-6-git-send-email-acourbot@nvidia.com> <20140925132717.GA13579@dusk.luon.net> <54243931.6050804@wwwdotorg.org> <20140925164109.GA30382@ulmo>
In-Reply-To: <20140925164109.GA30382@ulmo>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 10:41 AM, Thierry Reding wrote:
> On Thu, Sep 25, 2014 at 09:48:01AM -0600, Stephen Warren wrote:
>> On 09/25/2014 07:27 AM, Sjoerd Simons wrote:
>>> Playing a bit with todays linux-next on my jetson, it seems this patch is
>>> still required for enabling the GPU. Is there anything blocking it (firmware
>>> not available yet in liux-firmware?)
>>
>> I think initially I was waiting for the DRM patch "drm/nouvea: support for
>> probing platform devices" to be applied, but it looks like that's been
>> applied already, so only patches 4 and 5 in this series are still
>> outstanding.
>>
>> Alex, wasn't there also some issue where the VPR register had to be
>> programmed, and if it wasn't there'd be a hang when the GPU registers were
>> touched? If we've added code to Nouveau/tegradrm to detect that and avoid
>> the problem, then I guess we can commit these last two patches for 3.19. A
>> resend after the 3.18 merge window might help.
>
> A patch that programs VPR was merged into U-Boot (though I don't think
> it's made it into master yet). I'm not sure we can reasonably check for
> that in Nouveau, given that the register is somewhere completely
> unrelated. In fact I think the U-Boot patch was triggered by some
> discussion about how to solve this and it was decided that it shouldn't
> be done in the kernel, but U-Boot should set it up.
>
> That said, perhaps one solution would be to make U-Boot enable the gk20a
> device if it's set up the VPR and disable it otherwise?

For that to work, we'd need the DT to say status="disabled" by default 
for the GPU, and for the fixed U-Boot (and indeed every other 
bootloader...) to enable the GPU node. This would allow people with old 
versions of U-Boot (or other bootloaders) to continue to boot. This 
means bootloaders would only have to set status="okay", but never have 
to set status="disabled", which at least simplifies them a tiny bit.
