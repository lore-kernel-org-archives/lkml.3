Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbbAQWG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 17:06:57 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:51277 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbAQWGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 17:06:55 -0500
Message-ID: <54BADCFB.5010805@cogentembedded.com>
Date: Sun, 18 Jan 2015 01:06:51 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        sboyd@codeaurora.org
CC: linux-sh@vger.kernel.org
Subject: Re: [PATCH] clk-gate: fix bit # check in clk_register_gate()
References: <2500887.6mMDBajo0S@wasted.cogentembedded.com> <20150117220116.22722.808@quantum>
In-Reply-To: <20150117220116.22722.808@quantum>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/18/2015 01:01 AM, Mike Turquette wrote:

>> In case CLK_GATE_HIWORD_MASK flag is passed to clk_register_gate(), the bit #
>> should be no higher than 15, however the corresponding check is obviously off-
>> by-one.

>> Fixes: 045779942c04 ("clk: gate: add CLK_GATE_HIWORD_MASK")
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

> Applied to clk-next. Thanks! Is this causing a visible regression for
> you? It is not a new bug so I'd prefer to send it though clk-next unless
> something is blowing up on your end.

    No, nothing, I don't even call this function (was using composite clock). 
Found by just looking at the code.

>> ---
>> The patch is against Linus' repo because the 'clk-fixes' branch  in  Mike
>> Turquette's 'linux.git' repo at Linaro seems very outdated. BTW, the repo
>> at kernel.org specified by the MAINTAINERS file doesn't seem to exist --
>> can something be done about that?

> The clk-fixes branch at git.linaro.org is now updated and the clk tree
> at git.kernel.org is also live. Blame the holidays.

> For now they will mirror each other (and linux-next will continue to
> reference the one at git.linaro.org until 3.19 is released).

    Thank you.

> Regards,
> Mike

WBR, Sergei

