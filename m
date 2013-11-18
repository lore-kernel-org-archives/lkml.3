Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab3KROAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:00:34 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:16647 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3KROA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:00:28 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat6hNPnz40=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 0/3] omapdss: venc: Add support for bypass and acbias.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <528A1652.4000806@ti.com>
Date: Mon, 18 Nov 2013 15:00:20 +0100
Cc: Belisko Marek <marek.belisko@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Marek Belisko <marek@goldelico.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <3C198737-CAE0-40B4-803F-31C132911265@goldelico.com>
References: <1381784555-18344-1-git-send-email-marek@goldelico.com> <CAAfyv34j+YhEjtHyf7zg5oBoCV5ROEXow8VV0PQNHLTF5uDZJg@mail.gmail.com> <5280DBA6.50303@ti.com> <FB10035C-B13C-4A03-BE9C-0576806F2577@goldelico.com> <5280E617.3000004@ti.com> <F97741D2-FC6F-4DBD-A0DD-E35304501993@goldelico.com> <528A1652.4000806@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Am 18.11.2013 um 14:29 schrieb Tomi Valkeinen:

> On 2013-11-11 16:30, Dr. H. Nikolaus Schaller wrote:
> 
>> Maybe it looks as if it is an unsolvable problem. The OPA works only if acbias
>> and bypass are enabled, but is not allowed to tell that it is there.
> 
> That's why the board file or dts file is there, to have "glue" data to
> make different pieces work together.

Our implementation idea was that this makes the board file developer to specify knowlegde that the
drivers already could have and to reduce the risk of misconfiguration.

So we tried to model the invert property of the connector which is also backpropagated
to VENC.

But of course there are different ways of doing it and different priorities of contradicting
requirements.

> 
> The perfect (?) solution would be a CDF like data. The idea would be
> that in the board file, you would describe configuration options for
> VENC and for OPA. In this particular case, you'd tell VENC that it needs
> to enable acbias and bypass when OPA is to be connected to VENC. Then
> there could be more entries for VENC, saying disable acbias and bypass
> when BAR is to be connected to VENC.
> 
> However, we don't have such support (yet).
> 
> For now, I hope it's enough if we handle VENC in a "single
> configuration" manner, i.e. you'll tell VENC to enable acbias and bypass
> when VENC is enabled. This means you can't have board setups where you'd
> change the VENC->OPA connection to some other analog tv output at
> runtime. I hope that's the case (i.e. OPA is always in use on that board).

I also don't think that there is a need for runtime modifications, so your proposal
looks ok.

> If so, then I think you can just pass the acbias and bypass
> configuration values via omapdss platform data. And VENC driver will use
> them to configure those. OPA doesn't know anything about this at all.

We will change it that way.

Do you see a chance to get it into the merge window of 3.13?

BR,
Nikolaus