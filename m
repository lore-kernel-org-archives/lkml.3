Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3EBWKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 18:10:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55347 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3EBWKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 18:10:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
Date: Fri, 3 May 2013 00:09:56 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "Jean-Francois Moine" <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com> <alpine.LFD.2.02.1305022324371.2891@ionos> <5182E11E.5010103@gmail.com>
In-Reply-To: <5182E11E.5010103@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305030009.57041.arnd@arndb.de>
X-Provags-ID: V02:K0:Ua0kttgMIfWb1W9PtTgz0zK7U463wt7NhQeHgPqPf4D
 GzoU/pviHyBRM4khmPUIZfyehQPFYW7BledLhowtYFSye9T5sD
 3fCd+fFtCWa5ck774JXakxCM9CwP2/L+mHpGxTlVbF/ePQK4Az
 1UHj0wjezEuTRS18wi5Dxm/GTE2wVKUSnCdFmsMkrwZ4SQS2uB
 yGvTf2JvmDtR6ahxZ33YqP2X4B29tP3ekL2FCZAr7wqZmvRZTu
 irgRZcgOFSVBJy3EJWcur9a7yL6DvGJ2FbA36zm4louTchjX0I
 C8ZBW5QkJ7aZ7834Caf1x1k9qOwmhmW8qYrt8yiCu6RdIDf25p
 btcxTjz3KlInDSsNeCXE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Sebastian Hesselbarth wrote:
> > Just look at the various implementations in drivers/irqchip/ and find
> > out how similar they are. Moving code to drivers/irqchip/ does not
> > make an excuse for reestablishing the mess which was addressed by the
> > generic irq chip implementation.
> >
> > Can you - and that means all of you ARM folks - please get your gear
> > together and add the missing features to the generic irq chip
> > implementation? I'm not going to accept more of that OF/DT frenzy.
> 
> So you are suggesting to have a "linux,generic-intc" or you want me
> to have "marvell,orion-intc" make use of generic irq chip again?
> 
> The second is easy, the first will take me a while to think about
> proper DT properties how to encode mask/unmask/ack/.. availability
> and offsets.

I think it should not be "linux,..." since the description can
well be OS independent. I don't have a good idea for a generic
name, but it's not very important.

The main missing piece in the generic irqchip code at the moment
is support for the linear irqdomain. Once we have that, a lot of
code can be simplified significantly.

	Arnd
