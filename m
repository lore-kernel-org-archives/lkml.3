Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaGCNvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:51:37 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15272 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaGCNvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:51:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 03 Jul 2014 06:41:10 -0700
Message-ID: <53B55FE3.6010202@nvidia.com>
Date: Thu, 3 Jul 2014 16:51:31 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] thermal: Add Tegra SOCTHERM thermal management driver
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com> <1403856699-2140-7-git-send-email-mperttunen@nvidia.com> <53B1D538.6000704@wwwdotorg.org> <53B26BF2.7090009@nvidia.com> <53B2FD61.9000101@wwwdotorg.org>
In-Reply-To: <53B2FD61.9000101@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/07/14 21:26, Stephen Warren wrote:
>
> Ah, so there's some manufacturing calibration process that sets some
> fuse value, and the HW uses a combination of that fuse value, and some
> parameters of the manufacturing process as represented by the
> SENSOR_CONFIG2 register, to apply the calibration? I wonder why
> SENSOR_CONFIG2 is a register not a fuse in that case, but anyway...
>
> Perhaps some comments or kerneldoc in the definition of struct
> tegra_tsensor would be useful?

Yes, I'll add some comments.

>
> Why not read THERMCTL_INTR_STATUS inside the IRQ thread. IIRC, if the
> ISR wakes an IRQ thread, the interrupt remains disable until the thread
> has run its course, so there's no issue deferring the register read
> until the thread runs, at which point, the thread can simply loop over
> all the sensors.
>

If that's the case, then that's definitely a better way to do it.
