Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaE0Whp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:37:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45592 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaE0Whn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:37:43 -0400
Message-ID: <538513B0.2020903@gmail.com>
Date: Wed, 28 May 2014 00:37:36 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org
CC: Jason Cooper <jason@lakedaemon.net>, Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 2/2] ARM: dts: mvebu: split SolidRun CuBox into variants
References: <1401140009-31505-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140527213549.GU8664@titan.lakedaemon.net> <538508A5.2010809@gmail.com> <32589428.8iAxtgFCnl@phil>
In-Reply-To: <32589428.8iAxtgFCnl@phil>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 12:24 AM, Heiko Stübner wrote:
> Am Dienstag, 27. Mai 2014, 23:50:29 schrieb Sebastian Hesselbarth:
>> On 05/27/2014 11:35 PM, Jason Cooper wrote:
>>> On Tue, May 27, 2014 at 07:28:09PM +0200, Sebastian Hesselbarth wrote:
>>>> On 05/27/2014 06:11 PM, Jason Cooper wrote:
>>>>> On Mon, May 26, 2014 at 11:33:29PM +0200, Sebastian Hesselbarth wrote:
>>> info.  It may be useful here, but I'd like to hear from the DT
>>> maintainers how they want it used.  eg: most popular first, like you
>>> have it, or oldest first
>>>
>>> dove-cubox-es.dts
>>> +--> dove-cubox.dts
>>
>> In the cubox case, this is not possible. ES has a misrouted
>> card-detection for sdhci, this requires an additional property.
>> There is no way to remove a property once it is written down in
>> any of the files included. But you know about that already.
> 
> dtc knows "/delete-property/" [0], but I may be missing something here.
> 
> [0] https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-August/018169.html

Heiko,

thanks for the link, I must have completely ignored it! Now that I
think about it, it may be very useful for kirkwood-98xsomething.dtsi
that is a special Kirkwood with a bunch of IP removed (but only some
boards). That way we could consolidate the common SoCs and use
/delete-node/ for the special case SoC.

Anyway, for CuBox ES, I either prefer the v2 approach just send - or
have a cubox-common.dtsi with two board dts for 1G and ES each. We use
this structure a lot and Andrew showed it even works for up to 5 or 10
different variants.

Sebastian

