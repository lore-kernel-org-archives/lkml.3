Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaIZEpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:45:35 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3001 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaIZEpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:45:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 25 Sep 2014 21:45:16 -0700
Message-ID: <5424EF43.300@nvidia.com>
Date: Fri, 26 Sep 2014 13:44:51 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Sjoerd Simons <sjoerd@luon.net>
CC: Ben Skeggs <bskeggs@redhat.com>, Thierry Reding <thierry.reding@gmail.com>,
        <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>
Subject: Re: [5/5] ARM: tegra: jetson-tk1: enable GK20A GPU
References: <1400491450-19223-6-git-send-email-acourbot@nvidia.com> <20140925132717.GA13579@dusk.luon.net> <54243931.6050804@wwwdotorg.org>
In-Reply-To: <54243931.6050804@wwwdotorg.org>
X-NVConfidentiality: public
X-Originating-IP: [10.19.57.128]
X-ClientProxiedBy: DRBGMAIL102.nvidia.com (10.18.16.21) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 12:48 AM, Stephen Warren wrote:
> On 09/25/2014 07:27 AM, Sjoerd Simons wrote:
>> Playing a bit with todays linux-next on my jetson, it seems this patch is
>> still required for enabling the GPU. Is there anything blocking it
>> (firmware
>> not available yet in liux-firmware?)
>
> I think initially I was waiting for the DRM patch "drm/nouvea: support
> for probing platform devices" to be applied, but it looks like that's
> been applied already, so only patches 4 and 5 in this series are still
> outstanding.

Actually I am waiting for the firmware and firmware loading support 
patch to land in linux-firmware and Nouveau respectively. I have yet to 
send these patches publicly due to some ongoing discussion about the 
firmware's license.

For now if you want to run Nouveau on TK1, the easiest solution is to 
use my kernel and Nouveau branches. The branches that should be used are 
visible in the manifest of 
https://github.com/Gnurou/tegra-nouveau-rootfs - which BTW also provides 
an easy way to enable the FOSS graphics stack on a L4T image (minus the 
firmware at the moment).

More generally speaking, I still have a lot of patches to upstream - I 
apologize for not having been able to catch up with them. Things have 
been busy on other fronts, but since these other fronts are soon not 
going to be a concern anymore I will be able to focus on Nouveau again 
after mid-next week. :)

>
> Alex, wasn't there also some issue where the VPR register had to be
> programmed, and if it wasn't there'd be a hang when the GPU registers
> were touched? If we've added code to Nouveau/tegradrm to detect that and
> avoid the problem, then I guess we can commit these last two patches for
> 3.19. A resend after the 3.18 merge window might help.

The VPR patch has landed in U-boot mainline, so this should be less of a 
problem now. AFAIK there is no safe way to check whether VPR has been 
disabled, but the solution might be in your suggestion to make the 
bootloader enable the GPU DT node if it finds it safe to do so.
