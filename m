Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaFKP6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:58:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44260 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbaFKP6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:58:32 -0400
Message-ID: <53987CA4.4040506@wwwdotorg.org>
Date: Wed, 11 Jun 2014 09:58:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 3/5] misc: fuse: Add efuse driver for Tegra
References: <1401973754-19701-1-git-send-email-pdeschrijver@nvidia.com> <1401973754-19701-4-git-send-email-pdeschrijver@nvidia.com> <53984FE3.6010509@nvidia.com> <20140611152551.GH5961@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20140611152551.GH5961@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 09:25 AM, Peter De Schrijver wrote:
> On Wed, Jun 11, 2014 at 02:47:31PM +0200, Mikko Perttunen wrote:
>> On 05/06/14 16:09, Peter De Schrijver wrote:
>> ...
>>> +int tegra_fuse_readl(u32 offset, u32 *val)
>>> +{
>>> +       if (!fuse_readl)
>>> +               return -ENXIO;
>>> +
>>> +       *val = fuse_readl(offset);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>
>> -EPROBE_DEFER would be a better error value, so that drivers can work 
> 
> Ok.
> 
>> even if they are initially probed before the fuse driver. Of course, if 
>> the fuse initialization is moved into machine init then this is a non-issue.
> 
> The exported function will always be initialized later because on Tegra20 it
> requires APB DMA to be available. If you read the fuses directly, the system
> sometimes hangs.

That's not true in the current code. IIRC, the bug was that *if* an APB
DMA access to anything and a CPU access to the fuses happen at the same
time, then there can be a hang. As such, the current fuse code accesses
the fuses directly (without potential for a hang) if the APB DMA driver
is not available, but once the driver becomes available, it reads the
fuses through DMA instead. Does the new code not do that?

