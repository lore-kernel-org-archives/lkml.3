Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081Ab3CSVm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:42:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39350 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933940Ab3CSVmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:42:25 -0400
Message-ID: <5148DBBD.8020506@wwwdotorg.org>
Date: Tue, 19 Mar 2013 15:42:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: add table lookup to mux
References: <1363113747-6572-1-git-send-email-pdeschrijver@nvidia.com> <20130319213309.8663.17375@quantum>
In-Reply-To: <20130319213309.8663.17375@quantum>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 03:33 PM, Mike Turquette wrote:
> Quoting Peter De Schrijver (2013-03-12 11:42:23)
>> Add a table lookup feature to the mux clock. Also allow arbitrary masks
>> instead of the width. This will be used by some clocks on Tegra114. Also
>> adapt the tegra periph clk because it uses struct clk_mux directly.
>>
>> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> Do you actually need arbitrary masks instead of a continuous bitfield?
> Or does this change just make it easier for you to convert existing
> data?

Yes, Peter mentioned somewhere that Tegra apparently has some registers
where the mux bits are split up into non-contiguous regions of a register.
