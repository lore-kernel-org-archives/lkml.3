Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaAFSNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:13:36 -0500
Received: from mo6.mail-out.ovh.net ([178.32.228.6]:50134 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbaAFSNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:13:35 -0500
MIME-Version: 1.0
In-Reply-To: <1460399.vQDGWoVpz2@wuerfel>
References: <1388507534-10570-1-git-send-email-jjhiblot@traphandler.com>
	<4526077.qASk8HSHKP@wuerfel>
	<CACh+v5PptkrXERAqBUOv-DSaRDQ5NzJAc919Ne3iN9iVszRP+A@mail.gmail.com>
	<1460399.vQDGWoVpz2@wuerfel>
Date: Mon, 6 Jan 2014 19:13:27 +0100
Message-ID: <CACh+v5Mt=bnfnZpux1veEtiOpc1M_yryuy=bDvMOOJf5RT6WxQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] at91: dt: sam9261: Added DM9000 in the device tree
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        boris brezillon <b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 17584304745620461592
X-Ovh-Remote: 209.85.160.53 (mail-pb0-f53.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

sorry for the delay. I'll rework the driver to include some ideas
proposed by you and Boris. Boris proposed to have several timing
decoders (a generic one, one for NAND and so on). I plan to use the
compatibility name to select the decoder.and use the DT representation
you proposed last : one top "simple-bus" and one sub-node "atmel,smc"
per chip-select with one (or more) sub-device per chip-select.

Jean-Jacques




2014/1/2 Arnd Bergmann <arnd@arndb.de>:
> On Thursday 02 January 2014 20:31:00 Jean-Jacques Hiblot wrote:
>> > If each bus interface has a fixed range of registers, you can actually
>> > collapse the upper two nodes again and just have one device per
>> > chipselect.
>> This is indeed the case, but I'd rather keep the top node to highlight
>> the fact that all the devices are physically tied to the same bus.
>
> How about using a top-level "simple-bus" node with the complex ranges
> property but making the driver match the sub-devices with the smaller
> register range then?
>
>         Arnd
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
