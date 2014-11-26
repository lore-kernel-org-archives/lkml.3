Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaKZT5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:57:45 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:56977 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaKZT5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:57:44 -0500
Message-ID: <547630AD.1010108@mentor.com>
Date: Wed, 26 Nov 2014 21:57:33 +0200
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Question about fixed regulator DT properties
References: <546B5EF9.3080102@mentor.com> <546CAB49.8030103@mentor.com> <20141125121749.GV7712@sirena.org.uk> <54760D6A.9080306@mentor.com> <20141126175304.GM7712@sirena.org.uk> <5476266E.9040901@mentor.com> <20141126192021.GU7712@sirena.org.uk>
In-Reply-To: <20141126192021.GU7712@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.11.2014 21:20, Mark Brown wrote:
> On Wed, Nov 26, 2014 at 09:13:50PM +0200, Vladimir Zapolskiy wrote:
> 
>> If I want to enable a fixed regulator (not controlled by
>> bootloader/firmware) by Linux on boot or when fixed.ko module is bound,
>> shall I specify the same "regulator-boot-on" property? At least this is
>> the practical way to enable a fixed and/or gpio regulator right now, but
>> is it correct?
> 
> It depends what you're trying to accomplish by doing this.

If "regulator-boot-on" is specified and the regulator is enabled by
bootloader/firmware, then the kernel re-enables it.

If "regulator-boot-on" is specified and the regulator is untouched by
bootloader/firmware, then the kernel simply enables it.

As far as I understand the latter side-effect is exploited on quite many
ARM boards, when there is no defined regulator consumer, but I agree
that it looks hackish. My assumption is that probably fixed regulator
logic around "regulator-boot-on" property should be changed, so that the
kernel will not attempt to physically re-enable/enable the
"regulator-boot-on" regulator at all, then misusage of the property
should gone forced by necessity of finding a proper regulator consumer.

>> Or should the regulator always be enabled externally (assuming
>> "regulator-always-on" is omitted) after registration independently on
>> "regulator-boot-on" property?
> 
> Best practice is that there should be a consumer which keeps the
> regulator enabled whenever it is required.  There should normally be
> little use for boot-on, it's mostly there to ease handover from the
> bootloader in cases where we can't read the hardware state - if you're
> not sure if you should use it the chances are you shouldn't.
> 

Right, thank you for explanation.

--
With best wishes,
Vladimir
