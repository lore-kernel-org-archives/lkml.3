Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313Ab3JPROf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:14:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37697 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761257Ab3JPROc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:14:32 -0400
Message-ID: <525EC973.7060802@wwwdotorg.org>
Date: Wed, 16 Oct 2013 11:14:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 00/19] Introduce common infra for tegra clocks
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com> <525D8009.5040907@wwwdotorg.org> <20131016090643.GI5643@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20131016090643.GI5643@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 03:06 AM, Peter De Schrijver wrote:
> On Tue, Oct 15, 2013 at 07:48:57PM +0200, Stephen Warren wrote:
>> On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
>>> This patchset introduces common infrastructure for clocks which exist in                                                                                       
>>> several Tegra SoCs. We also also move Tegra20, Tegra30 and Tegra114 to
>>> this new infrastructure.
...
>> Testing on Venice2 (Tegra124): I see the following WARN during boot,
>> which I think is new relative to the internal branch you gave me yesterday:
>>
>>> [    0.300450] WARNING: CPU: 0 PID: 1 at drivers/clk/tegra/clk.c:187 tegra_init_from_table+0x78/0x158()
...
>>> [    0.372440] [<c07b4c1c>] (tegra_init_from_table+0x78/0x158) from [<c07b4e10>] (tegra_clocks_apply_init_table+0x18/0x20)
>>> [    0.384138] [<c07b4e10>] (tegra_clocks_apply_init_table+0x18/0x20) from [<c079f9cc>] (tegra_dt_init+0xc/0xd8)
>>> [    0.394903] [<c079f9cc>] (tegra_dt_init+0xc/0xd8) from [<c079a580>] (customize_machine+0x1c/0x40)
...
> Did you see  'tegra_init_from_table: Failed to set parent pll_c2 of epp ' before? Tegra124 doesn't have EPP...

Yes, I get exactly that message. Sorry, I forgot to paste in the most
relevant line:-( I assume fixing this simply means removing an entry in
the init table in clk-tegra124.c, so should be simple.
