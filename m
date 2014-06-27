Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaF0QAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:00:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40438 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaF0QAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:00:02 -0400
Message-ID: <53AD94FD.2070400@wwwdotorg.org>
Date: Fri, 27 Jun 2014 09:59:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: export clock names for debugging
References: <1403797705-26910-1-git-send-email-pdeschrijver@nvidia.com> <53AC41B0.40307@wwwdotorg.org> <20140627121954.GR3679@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20140627121954.GR3679@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 06:19 AM, Peter De Schrijver wrote:
> On Thu, Jun 26, 2014 at 05:52:16PM +0200, Stephen Warren wrote:
>> On 06/26/2014 09:48 AM, Peter De Schrijver wrote:
>>> When writing a module for testing or debugging purposes, there is no way to
>>> get hold of clk handles. This patch solves this by exposing all valid clocks
>>> as clkdev's for the virtual device tegra-clk-debug.
>>
>> This is to support clk_get_sys()?
>>
> 
> Yes.
> 
>> I guess this seems fine, so feel free to apply it, but I slightly wonder
>> why not just include this change as part of the presumably local and
>> never-to-be-upstreamed test/dev module?
> 
> The idea is to allow local debug modules to get hold of the struct clk *. I
> don't think that's possible without using clk_get_sys()?

Well, for a debug hack you can always just add extra clock entries into
some DT node and so avoid clk_get_sys:-)

My point wasn't so much about not using clk_get_sys in a debug driver,
but more that if this patch is only required to support non-upstreamed
debug code, perhaps this patch should stay downstream along with that
non-upstreamed debug code. That said, I'm not really objecting to it,
just making a minor comment.
