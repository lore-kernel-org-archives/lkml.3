Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaDVSyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:54:35 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:63809 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaDVSye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:54:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKE_Z3kBhS1VaQADV5ob8x6AKHhbHaQEGoVSwkwdd50zA@mail.gmail.com>
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com>
	<1398181105-19714-2-git-send-email-antoine.tenart@free-electrons.com>
	<CAL_JsqKE_Z3kBhS1VaQADV5ob8x6AKHhbHaQEGoVSwkwdd50zA@mail.gmail.com>
Date: Tue, 22 Apr 2014 13:54:33 -0500
Message-ID: <CAL_JsqJwC2xcZakXiJXJscK7tN7xt2OotBKyr9u+aK3bOP+7GQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] ata: ahci: add AHCI support for Berlin SoCs
From: Rob Herring <robherring2@gmail.com>
To: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tejun Heo <tj@kernel.org>, zmxu@marvell.com,
        Jisheng Zhang <jszhang@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 1:47 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Tue, Apr 22, 2014 at 10:38 AM, Antoine Ténart
> <antoine.tenart@free-electrons.com> wrote:
>> Add support for the Berlin SoCs AHCI SATA controller allowing to
>> interface with devices like external hard drives.

One more thing.

>> +       nports = readl(hpriv->mmio + HOST_PORTS_IMPL);
>> +
>> +       /* force_map is modified only if the property is found */
>> +       of_property_read_u32(np, "marvell,force-port-map", &force_map);

This property does not appear to be documented.

>> +       if (force_map)
>> +               nports = force_map;

You don't need this as your comment says, you can just do:

of_property_read_u32(np, "marvell,force-port-map", &nports);

nports will only be changed if property is present.

Rob
