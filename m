Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3EBSUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:20:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56581 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab3EBSU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:20:29 -0400
Message-ID: <5182AE68.9010905@wwwdotorg.org>
Date: Thu, 02 May 2013 12:20:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Henningsson <david.henningsson@canonical.com>
CC: Mike Travis <travis@sgi.com>, Stephen Warren <swarren@nvidia.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH]: x86_64, audio: Fix system panic when DMA > 40 bits
References: <1367435048-66137-1-git-send-email-travis@sgi.com> <518205A9.1050409@canonical.com>
In-Reply-To: <518205A9.1050409@canonical.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 12:20 AM, David Henningsson wrote:
> On 05/01/2013 09:04 PM, Mike Travis wrote:
>> The audio driver mistakenly allows 64 bit addresses to be created for
>> the audio driver on Nvidia GPUs.  Unfortunately, the hardware normally
>> only supports up to 40 bits of DMA.  This can cause system panics as
>> well as misdirected data when the address is > 40 bits as the upper
>> part the address is truncated.
> 
> Thanks for this patch. Stephen Warren, is this something you can
> confirm/deny, and do you know what range of hardware this actually
> applies to?

It's certainly plausible that the GPU's internal physical addresses are
less than a full 64-bits, and this probably affects PCI accesses too.
