Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474Ab3BMQua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:50:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45048 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934169Ab3BMQu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:50:28 -0500
Message-ID: <511BC451.9050504@wwwdotorg.org>
Date: Wed, 13 Feb 2013 09:50:25 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "marvin24@gmx.de" <marvin24@gmx.de>, "balbi@ti.com" <balbi@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v2 3/3] ARM: tegra: Unify Device tree board files
References: <20130212.070456.532657136988541923.hdoyu@nvidia.com><201302121350.15683.arnd@arndb.de><511A6F6C.8090205@wwwdotorg.org> <20130213.081240.1605796167151164030.hdoyu@nvidia.com>
In-Reply-To: <20130213.081240.1605796167151164030.hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 11:12 PM, Hiroshi Doyu wrote:
> Stephen Warren <swarren@wwwdotorg.org> wrote @ Tue, 12 Feb 2013 17:35:56 +0100:
> 
>> However I'd like to avoid changing the body of those two functions at
>> all if possible, since I hope the PCIe driver rework will be merged in
>> 3.10, and that will allow the Harmony and TrimSlice init functions to be
>> removed entirely. I'd rather not have conflicts with the removal patch.
>>
>>> Since we are not going to add any other board specfic init functions, you
>>> can also unroll the loop and put everything into tegra_dt_init_late:
>>
>> That's not necessarily true. While we certainly don't plan to, I don't
>> think we can rule it out; after all, we don't have rfkill bindings and
>> yet other boards will need them.
> 
> Considering the above points,
> 
> - The Harmony and TrimSlice init functions will be removed entirely
>   so soon that we want to avoid those merge conflicts as much as
>   possible.
> - We may still need board specific init, especially for rfkill.
> - We want to build any combination of Tegra{20,30,114}, 2^3 - 1 == 7.
> 
> The patch for "tegra.c" would be as below.
> 
> Should I still keep the name, "tegra20_auxdata_lookup" to avoid
> any conflicts or "tegra_auxdata_lookup" would be ok for merge?

Yes, avoiding the rename of the auxdata table might be a good idea.

Aside from that, I think the patch you gave looks fine.
