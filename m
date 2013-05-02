Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086Ab3EBSme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:42:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40967 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760697Ab3EBSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:42:33 -0400
Message-ID: <5182B396.308@wwwdotorg.org>
Date: Thu, 02 May 2013 12:42:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, djbw@fb.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: tegra: implement suspend/resume callbacks
References: <1366797267-29567-1-git-send-email-ldewangan@nvidia.com> <20130430103046.GD1960@intel.com>
In-Reply-To: <20130430103046.GD1960@intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 04:30 AM, Vinod Koul wrote:
> On Wed, Apr 24, 2013 at 03:24:27PM +0530, Laxman Dewangan wrote:
>> Implement suspend/resume callbacks to store APB DMA channel's
>> register on suspend and restore APB DMA channel's register on
>> resume.
...
> You dont seem to handle suspend when DMA is active? Otherwise looks fine.
> Stephen, you okay with this patch?

Yes, I think this looks fine. Sorry for the slow response; I was on
vacation.

One question though: Laxman mentioned that DMA clients were responsible
for suspending their DMA accesses themselves. Does the dmaengine core
define the semantics here; are DMA drivers supposed to handle suspend
with active DMAs, or should DMA clients suspend their DMA accesses
themselves as Laxman suggests? If the latter, I wonder if we actually
need to save/restore all the registers, since after resume, a new DMA
access would be started in all cases, which would then reprogram the HW.
