Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbbAWKYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:24:52 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37300 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbbAWKYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:24:49 -0500
Message-ID: <54C22169.2000600@collabora.com>
Date: Fri, 23 Jan 2015 11:24:41 +0100
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v11 2/4] clk: Make clk API return per-user struct clk
 instances
References: <1421847039-29544-1-git-send-email-tomeu.vizoso@collabora.com> <1421847039-29544-3-git-send-email-tomeu.vizoso@collabora.com> <20150122010136.GH27202@codeaurora.org> <54C0DBD6.2000502@collabora.com> <20150122185923.GL27202@codeaurora.org>
In-Reply-To: <20150122185923.GL27202@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 07:59 PM, Stephen Boyd wrote:
> On 01/22, Tomeu Vizoso wrote:
>> On 01/22/2015 02:01 AM, Stephen Boyd wrote:
>>> BTW, please try and fixup checkpatch warnings.
>>
>> What were you thinking of specifically? I'm running it with
>> --max-line-length=106 and the other warnings are in clk-test.c that I
>> still have to polish when I get some time.
> 
> I can see that sometimes we exceed the 80 character limits that
> are configured by default. We mostly stick to 80 in this file it
> seems so I'm not sure why 106 is being used.

Well, if I run checkpatch.pl with the default, I get the 80 char limit
which I think worsens readability. I use 106 as an arbitrary placeholder
for "a bit more than 80", taken from
https://lkml.org/lkml/2009/12/17/229 . I'm reformatting to 80 columns.

>>>
>>> And we do it here where we could remove the #ifdef.
>>
>> Yeah, I tried to reduce the ifdefing back then and this is the simplest
>> I could come up with. The reason for clk_get() to call
>> __clk_create_clk() directly is that it has more relevant information
>> with which to tag the per-user clk.
>>
>> of_clk_get_by_name() has the name of the node but not the dev_id, which
>> in my testing looked as much less useful when debugging who did what to
>> a clock.
>>
> 
> Agreed. But didn't we add __of_clk_get_by_name() so that we could
> pass the dev_id and con_id to it? If we did that then all the
> relevant information is there and we can call __clk_create_clk()
> directly instead of relying on the caller to do it.

Ah, that sounds much better indeed.

Will be sending v13 shortly.

Thanks,

Tomeu
