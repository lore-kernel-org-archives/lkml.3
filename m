Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaLYNnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 08:43:08 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:56504 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaLYNnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 08:43:05 -0500
Message-ID: <549C1465.6030909@gmail.com>
Date: Thu, 25 Dec 2014 14:43:01 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Evgeni Dobrev <evgeni@studio-punkt.com>, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/1] add support for Seagate BlackArmor NAS220
References: <20141215203855.GA28940@anne> <20141222125750.GA29163@anne> <549C0C3C.8060601@gmail.com> <20141225133109.GI19265@lunn.ch>
In-Reply-To: <20141225133109.GI19265@lunn.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.12.2014 14:31, Andrew Lunn wrote:
> On Thu, Dec 25, 2014 at 02:08:12PM +0100, Sebastian Hesselbarth wrote:
>>> +			status = "okay";
>>> +		};
>>> +
>>> +		sata@80000 {
>>> +			status = "okay";
>>> +			nr-ports = <2>;
>>
>> I need some update from the other mvebu guys here: Do we have SATA
>> PHY nodes in v3.19 for Kirkwood already? If so, please update to the
>> new binding.
>
> Hi Sebastian
>
> I'm not sure what you mean here. The binding Documentation says:

I was hoping that using phys/phy-names would allow us to get rid of
nr-ports property. I haven't checked the corresponding code and likely
will not before next year, but we should try to get rid of the nr-ports
property completely.

> Required Properties:
> - compatibility : "marvell,orion-sata" or "marvell,armada-370-sata"
> - reg           : Address range of controller
> - interrupts    : Interrupt controller is using
> - nr-ports      : Number of SATA ports in use.
>
> Optional Properties:
> - phys          : List of phandles to sata phys
> - phy-names     : Should be "0", "1", etc, one number per phandle
>
> The optional phys/phy-names have just been added to
> kirkwood-6192.dtsi.

Yeah, saw that patch after the review.. and my understanding of the
phys/phy-names properties is that
(a) they allow to count the number of _available_ ports
(b) they allow to determine the number of _used_ ports
(c) they allow to e.g. disable port 0 but enable port 1

while nr-ports only allows (a). You can derive (b) only if you use
the first out of two but you cannot do (c) with nr-ports.

Which is why we introduced the phys/phy-names properties.

Sebastian

