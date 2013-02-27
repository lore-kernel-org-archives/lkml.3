Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3B0GcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 01:32:25 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19132 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3B0GcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 01:32:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 26 Feb 2013 22:30:34 -0800
Date: Wed, 27 Feb 2013 08:32:13 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [REPOST PATCH 1/2] clk: add table lookup to mux
Message-ID: <20130227083213.aa234eea89272b09d6551f78@nvidia.com>
In-Reply-To: <1361545358-22721-2-git-send-email-pdeschrijver@nvidia.com>
References: <1361545358-22721-1-git-send-email-pdeschrijver@nvidia.com>
	<1361545358-22721-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013 16:02:28 +0100
Peter De Schrijver <pdeschrijver@nvidia.com> wrote:

> Add a table lookup feature to the mux clock. Also allow arbitrary masks
> instead of the width. This will be used by some clocks on Tegra114.
>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
....
> @@ -42,7 +43,17 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
>  	 * val = 0x4 really means "bit 2, index starts at bit 0"
>  	 */
....
> +	if (mux->table) {
> +		int i;
> +
> +		for (i = 0; i < num_parents; i++)
> +			if (mux->table[i] == val)
> +				return i;
> +		if (i == num_parents)
> +			return -EINVAL;
> +	}

Can't we just return after for-loop without checking i == num_parents as below?

+		for (i = 0; i < num_parents; i++) {
+			if (mux->table[i] == val)
+				return i;
+		}
+
+		return -EINVAL;
