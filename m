Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbbAZLmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:42:43 -0500
Received: from smtp-out-156.synserver.de ([212.40.185.156]:1040 "EHLO
	smtp-out-156.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbbAZLml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:42:41 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31145
Message-ID: <54C6282F.5010507@metafoo.de>
Date: Mon, 26 Jan 2015 12:42:39 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.4.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, tiwai@suse.de,
        perex@perex.cz
CC: devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 4/4] sound: jz4740: Enable codec clock during
 dai_probe
References: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422267511-6649-5-git-send-email-Zubair.Kakakhel@imgtec.com> <54C61980.9030205@metafoo.de> <54C62570.5050600@imgtec.com>
In-Reply-To: <54C62570.5050600@imgtec.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 12:30 PM, Zubair Lutfullah Kakakhel wrote:
>
> On 26/01/15 10:40, Lars-Peter Clausen wrote:
>> On 01/26/2015 11:18 AM, Zubair Lutfullah Kakakhel wrote:
>>> As we are moving away from platform to DT, we cant rely on the board
>>> file to do this now. So enable it here.
>>
>> I don't understand this changelog. The board file never did this. The driver enables the clock in the startup() callback.
>
> My bad.
>
> I couldn't get the ci20 audio to work without this change.
>
> I double checked. The clock is indeed enabled.
>
> But the rate needs to be set for the ci20.
>
> clk_set_rate(i2s->clk_i2s, 12000000);
>
> Where should I put it? I couldn’t trace how the rate is set for the jz4740..

There is no support for specifying clock rate defaults in the devicetree 
itself. See commit 86be408bfbd8 ("clk: Support for clock parents and rates 
assigned from device tree"). Since the preferred or correct clock rate will 
be board specific this is probably where it should go.

- Lars

