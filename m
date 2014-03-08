Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaCHLYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 06:24:52 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:34132 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaCHLYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 06:24:43 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2] dt: platform driver: Fill the resources before probe and defer if needed
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <CACh+v5N3Z=c1T3eGnjuudDkQH2YRW2knTunZtN=-64jHRT71OQ@mail.gmail.com>
References: <20140220153042.DF053C4050F@trevor.secretlab.ca> < 1392988720-20976-1-git-send-email-jjhiblot@traphandler.com> < 902E09E6452B0E43903E4F2D568737AB0B9D2959@DFRE01.ent.ti.com> < CACh+v5MPTx6nwVj1s3krntJqQ6DMTQ2hQ93Hc+rRNAuFa9+qPw@mail.gmail.com> < CACh+v5N3Z=c1T3eGnjuudDkQH2YRW2knTunZtN=-64jHRT71OQ@mail.gmail.com>
Date: Sat, 08 Mar 2014 07:32:38 +0000
Message-Id: <20140308073238.49318C404DA@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 17:43:15 +0100, Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:
> Hi Grant,
> 
> 2014-02-21 17:22 GMT+01:00 Jean-Jacques Hiblot <jjhiblot@traphandler.com>:
> > Hi Grygorii,
> >
> > 2014-02-21 16:37 GMT+01:00 Strashko, Grygorii <grygorii.strashko@ti.com>:
> >> Hi  Jean-Jacques,
> >>
> >> Sorry for top posting.
> >>
> >> As I know, there have been several attempts to solve the same problem already:)
> >> [1] https://lkml.org/lkml/2013/9/18/216
> >> [2] https://lkml.org/lkml/2013/11/22/520
> >> [3] https://lkml.org/lkml/2014/1/8/240
> >>
> >> There are some questions related to your approach:
> >> 1) How to distinguish between cases "IRQ domain not ready" and "wrong IRQ data in DT" or other IRQ parsing errors?
> >> Otherwise, Driver's probe will be deffered wrongly and forever,
> >> Thierry Reding has tried to solve this in [1].
> >
> > This approach doesn't really care about the cause of the problem.  I'm
> > of the opinion that never-ending deferred probing is not a big issue,
> > being not triggered so often after start-up (only when a new device is
> > probed). But if we need to make it right, then we would have to change
> > a bit the API of irq_create_of_mapping() and irq_of_parse_and_map()
> > (or maybe duplicate this one to keep the patch small) to return a real
> > error code instead a simple 0. Then would should be able to
> > distinguish the different error causes.
> 
> What do you think of the 2nd version of the patch? Is it all right to
> allways return EPROBE_DEFER or should we try to discriminate the error
> cause?

The error cause must be determined. It is explicitly allowed for a
single interrupt to be empty, and I believe there are users.

g.
