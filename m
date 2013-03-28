Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab3C1Pt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:49:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59712 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3C1Ptz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:49:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] ARM: irq: Call irqchit_init if no init_irq function is specified
Date: Thu, 28 Mar 2013 15:49:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com> <201303281525.42334.arnd@arndb.de> <20130328153617.GC3368@n2100.arm.linux.org.uk>
In-Reply-To: <20130328153617.GC3368@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303281549.49990.arnd@arndb.de>
X-Provags-ID: V02:K0:lEaJv5GjWmIDQ9zfEdUtVpg9zFBbBVEOYxgeTznMrx8
 TRa0bJzkDe8/BByhrMI3vM2/+qM1pFtw8Mm6Td4As2+xLn5tko
 kIHnDo0Iw1mOrCcAjcWSzv/TqrDG4CWzuV25ftEv8xyNKOhyaS
 Qkcdhtdbz5x3T0jGu+B5Cd0sHmQS3KWUrhebCK9VyBoZNLJ+Da
 bSqEyxho5eqJzJDLkwbmsuEA7Ef37OVTa8/Jzie64+AOAVESmR
 fyrOy9G3Qgy0FBTzKtAhBK/HxGua5RWfuphbPfdhyzS/Vfna4d
 kJJ0ScZy4+m1DfTrC81zy9ho02Q/nveLVjrKip3VBb4oFmccM1
 6iHfF6z35IJuBEkYBFL8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 March 2013, Russell King - ARM Linux wrote:
> On Thu, Mar 28, 2013 at 03:25:42PM +0000, Arnd Bergmann wrote:
> >       if (IS_DEFINED(CONFIG_OF) && !machine_desc->init_irq)
> >               irqchip_init();
> >       else
> >               machine_desc->init_irq();
> > 
> > to the same effect.
> 
> Provided irqchip_init() keeps its prototype visible, then yes.

Yes, I checked that before my reply. We have a few function declarations
that are unfortunately completely hidden when some config symbol is not
defined, but this is not one of them.

	Arnd
