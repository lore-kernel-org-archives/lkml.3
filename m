Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab3BGTNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:13:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39843 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3BGTNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:13:41 -0500
Message-ID: <5113FCE2.5030705@wwwdotorg.org>
Date: Thu, 07 Feb 2013 12:13:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Implement locking for super clock
References: <1360254261-23000-1-git-send-email-pdeschrijver@nvidia.com> <20130207185742.11471.19037@quantum>
In-Reply-To: <20130207185742.11471.19037@quantum>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 11:57 AM, Mike Turquette wrote:
> Quoting Peter De Schrijver (2013-02-07 08:24:14)
>> Although tegra_clk_register_super_mux() has a lock parameter, the lock is not
>> actually used by the code. Fixed with this patch.
>>
>> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
>> ---
>>  drivers/clk/tegra/clk-super.c |   18 +++++++++++++++---
>>  1 files changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/clk/tegra/clk-super.c b/drivers/clk/tegra/clk-super.c
>> index 7ad48a8..2fd924d 100644
>> --- a/drivers/clk/tegra/clk-super.c
>> +++ b/drivers/clk/tegra/clk-super.c
>> @@ -73,7 +73,12 @@ static int clk_super_set_parent(struct clk_hw *hw, u8 index)
>>  {
>>         struct tegra_clk_super_mux *mux = to_clk_super_mux(hw);
>>         u32 val, state;
>> +       int err = 0;
>>         u8 parent_index, shift;
>> +       unsigned long flags = 0;
> 
> I don't think initializing flags to zero is necessary but it is not a
> big deal.  Is gcc throwing a warning?  Otherwise:
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>

I've applied this to Tegra's for-3.9/soc-ccf-fixes branch. If you want
to repost given Mike's comments, I can take an updated version.
