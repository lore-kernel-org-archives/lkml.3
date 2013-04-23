Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab3DWLJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 07:09:43 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:57620 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3DWLJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 07:09:29 -0400
MIME-Version: 1.0
In-Reply-To: <516BF4D2.8060901@gaisler.com>
References: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
	<1363355140-28216-3-git-send-email-andreas@gaisler.com>
	<CACRpkdYf7U=YY92Pma8+mWGALJvQDPU=d3x7Z6rX+rWkhuBANg@mail.gmail.com>
	<516BF4D2.8060901@gaisler.com>
Date: Tue, 23 Apr 2013 13:09:28 +0200
Message-ID: <CACRpkdYDBuXcPDzkpL2DeaWYBXJM78cUNQkw3Uga1MyGobMayw@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] gpio: grgpio: Add device driver for GRGPIO cores
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Larson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 2:38 PM, Andreas Larson <andreas@gaisler.com> wrote:
> On 2013-04-10 20:50, Linus Walleij wrote:

>>> +Required properties:
>>> +
>>> +- name : Should be "GAISLER_GPIO" or "01_01a"
>>
>> What is this? Don't we usually use a .compatible string for this?
>> Name? Que? Is that something legacy?
>
> Regarding using name, this is standard for SPARC. The names in the
> device tree originates from the PROM.
>
> The name field is the actually the first field checked for a match in
> of_match_node, followed by type then compatible. See
> http://lxr.free-electrons.com/source/drivers/of/base.c#L572
>
(...)
> As for the "01_01a", the LEON SPARC systems uses a plug&play to identify
> different IP cores in the system. When the PROM is unaware of the name
> of a certain core, the name field presented from the prom will be on
> this form. This is standard handling for LEON SPARC drivers.

Thanks for detailing this! There is such a big world out there sometimes.

I'm sort of wondering why we do things the way we do in the ARM DT
world sometimes. Specifically I suspect that we should be using
name or type rather than compatible for the ARM PrimeCells, which
are a sort of plug-n-play type devices, but I guess it's too late
to change that now...

Yours,
Linus Walleij
