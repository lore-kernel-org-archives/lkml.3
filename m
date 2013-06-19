Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334Ab3FSLWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:22:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1376 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934067Ab3FSLWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:22:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 19 Jun 2013 04:22:43 -0700
Message-ID: <51C19485.3000708@nvidia.com>
Date: Wed, 19 Jun 2013 19:22:45 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, <ccross@android.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <keescook@chromium.org>, <cbouatmailru@gmail.com>,
        <tony.luck@intel.com>
Subject: Re: [RFC PATCH 1/3] pstore-ram: use write-combine mappings
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Atomic operations are undefined behavior on ARM for device or strongly
> ordered memory types. So use write-combine variants for mappings. This
> corresponds to normal, non-cacheable memory on ARM. For many other
> architectures, this change should not change the mapping type.

Hi, all
I have met this problems on tegra soc.
I tried to use pstore-ram, but the system will hang up when run the
atomic_cmpxchg() in the buffer_start_add() or buffer_size_add(),
whatever I use iomapped or vmapped regions.

I tried to apply this patch set, it was failed with vmap, but if use
iomapped rgiions, the ldrex/strex can work on this memory, and the
ramoops driver can work.

Does there have any updates for this issue?
Or how can I debug it?

Thanks.
Wei.
