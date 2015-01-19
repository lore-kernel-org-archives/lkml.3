Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbbASRon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:44:43 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55578 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbASRom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:44:42 -0500
Message-ID: <54BD42D0.3020107@wwwdotorg.org>
Date: Mon, 19 Jan 2015 10:45:52 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra20: Store CPU "resettable" status in IRAM
References: <1421319545-23920-1-git-send-email-digetx@gmail.com> <1421319545-23920-2-git-send-email-digetx@gmail.com> <20150119141224.GF23778@ulmo.nvidia.com> <54BD3E3E.2040801@wwwdotorg.org> <54BD41D3.7030703@gmail.com>
In-Reply-To: <54BD41D3.7030703@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 10:41 AM, Dmitry Osipenko wrote:
> 19.01.2015 20:26, Stephen Warren пишет:
>> Hopefully this works out. I suppose it's unlikely anyone will be
>> running code on
>> the AVP upstrem, so any potential conflict with AVP's usage of IRAM
>> isn't likely
>> to occur.
>>
> I don't see how it can conflict with AVP code. First KB of IRAM is
> reserved for reset handler. Am I missing something?
>
>  From reset.h:
>
> /* The first 1K of IRAM is permanently reserved for the CPU reset
> handler */

I believe "CPU" in that context means AVP CPU. Still, I may not be 
correct, and to be honest it's likely not too well defined even if that 
comment seems clear-cut.

>> __tegra20_cpu1_resettable_status_offset has a lot of _ at the start.
>> Should the
>> symbol be named more normally? I guess at least it's consistent with the
>> existing very "underscory" __tegra_cpu_reset_handler_start.
> I also wasn't happy with "underscory" :) And yes, I left it for
> consistency. Please feel free to rename it, if needed.

