Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaF0WaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 18:30:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43912 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaF0WaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 18:30:12 -0400
Message-ID: <53ADF070.8050002@wwwdotorg.org>
Date: Fri, 27 Jun 2014 16:30:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 0/5] Per-user clock constraints
References: <1403855872-14749-1-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1403855872-14749-1-git-send-email-tomeu.vizoso@collabora.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 01:57 AM, Tomeu Vizoso wrote:
> Hi,
> 
> I'm retaking Rabin's patches [0] for splitting the clk API in two: one API for
> clk consumers and another for providers. The consumer API uses a clk structure
> that just keeps track of the consumer and has a reference to the actual
> clk_core struct, which is used internally.
> 
> I have kept a patch from Rabin that aims to aid in debugging nested
> enable/disable calls, though my personal aim is to allow more than one consumer
> to influence the final, effective rate. For now this is limited to setting
> floor and ceiling constraints.
> 
> For those functions in the consumer clk API that were called from providers, I
> have added variants to clk-provider.h that are the same only that accept a
> clk_core instead. In this first version of the patchset, these functions are
> prepended with two underscores and have the _internal suffix at the end. Mike
> has stated his preference of not prefixing with underscores any public API and
> I agree with him, but we still need a way to distinguish e.g. clk_set_parent()
> in the provider API from that in the consumer API (and from the lock-less
> variant in clk-provider.h!).

The name clk_provider_set_rate would be a good hint that it's an API for
clock providers not consumers.

The name clk_core_set_rate would be a good hint that the function takes
a clk_core object rather than the clk (client) object.

Neither names see too unwieldy to me.

Anyway, that's the color of my bikeshed:-)
