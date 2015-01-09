Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbbAIEgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 23:36:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60513 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbbAIEgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 23:36:04 -0500
Message-ID: <54AF5AB0.2050208@wwwdotorg.org>
Date: Thu, 08 Jan 2015 21:36:00 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Herring <robh@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, linux-tegra@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v5][resend v4] of: replace Asahi Kasei Corp vendor prefix
References: <878ulzx6hr.wl%kuninori.morimoto.gx@gmail.com>	<20140922130026.GK3290@leverpostej>	<CAMuHMdX22z97SbGS1HDiYfJ1PXxyEN2S8D7w4sr+4bUwD+mJZw@mail.gmail.com>	<20140922132743.GM3290@leverpostej>	<87y4rfhmgl.wl%kuninori.morimoto.gx@renesas.com>	<1415845309.4269.6.camel@perches.com>	<20141113025105.GA16652@verge.net.au>	<87vbmjhj00.wl%kuninori.morimoto.gx@renesas.com>	<20141113110740.GE3815@sirena.org.uk>	<87k32yd0bd.wl%kuninori.morimoto.gx@renesas.com>	<20141114093554.GC3810@ulmo>	<87y4ra8xac.wl%kuninori.morimoto.gx@renesas.com>	<5469CD47.3040409@cogentembedded.com>	<877fytxsde.wl%kuninori.morimoto.gx@renesas.com>	<87egsob2cl.wl%kuninori.morimoto.gx@renesas.com>	<5478603D.1080404@cogentembedded.com>	<87d282sl6w.wl%kuninori.morimoto.gx@renesas.com>	<87lhm7t37l.wl%kuninori.morimoto.gx@renesas.com> <87egr4vcxu.wl%kuninori.morimoto.gx@renesas.com>
In-Reply-To: <87egr4vcxu.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 08:40 PM, Kuninori Morimoto wrote:
> 
> Hi Stephen, Olof, Arnd, Rob, Andrew
> 
> I'm sending this "of: replace Asahi Kasei Corp vendor prefix" during
> half-year (since Jun 2014) , many times. But, no-one care it.
> I don't know who is the best maintainer.
>  - Stephen : because it has Tegra ?
>  - Olof    : because it has Tegra (= ARM) ?
>  - Arnd    : because it has Tegra (= ARM) ?
>  - Matthias: because it has Tegra (= ARM SoC) ?
>  - Rob     : because DT ?
>  - Andrew  : Last chance ?
> 
> But, could you please care this patch ?
> I will re-send it again

It doesn't seem to be ack'd by any of the DT maintainers. Retro-actively
changing a DT vendor name would need that, I think.

Thierry and Alex (both Tegra maintainers) appear to have ack'd it, so it
seems they expect it to go through some tree other than Tegra. Weren't
there a bunch of related patches along with this (e.g. updating relevant
drivers to support both prefixes?) so it was expected this patch would
be applied together with them?

>> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>>
>> Current vendor-prefixes.txt already has "ak" prefix for Asahi Kasei Corp
>> by ae8c4209af2c(of: Add vendor prefix for Asahi Kasei Corp.)
>>
>> It went through the appropriate review process. But, almost all
>> Asahi Kasei chip drivers are using "asahi-kasei" prefix today.
>> (arch/arm/boot/dts/tegra20-seaboard.dts only is using "ak,ak8975",
>>  but there are instances of "asahi-kasei,ak8975" in other dts files.
>>  And drivers/iio/magnetometer/ak8975.c doesn't support "ak,ak8975" prefix)
>> So, we made a mistake there.
>>
>> In addition, checkpatch.pl reports WARNING if it is using "asahi-kasei"
>> prerfix in DT file.
>> (DT compatible string vendor "asahi-kasei" appears un-documented)
>>
>> Marking it deprecated and warning with checkpatch is certainly
>> preferable. So, this patch replace "ak" to "asahi-kasei" in
>> vendor-prefixes.txt. (and fixup tegra20-seaboard)
>>
>> OTOH, Asahi Kasei is usually referred to as "AKM", but this patch
>> doesn't care about it. Because no DT is using that today.
>>
>> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>> Acked-by: Thierry Reding <treding@nvidia.com>
>> Acked-by: Alexandre Courbot <acourbot@nvidia.com>

>> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt

>> -ak	Asahi Kasei Corp.

>> +asahi-kasei	Asahi Kasei Corp.

>> diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts

>>  		magnetometer@c {
>> -			compatible = "ak,ak8975";
>> +			compatible = "asahi-kasei,ak8975";

