Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbbABVXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:23:02 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:51281 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbbABVXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:23:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: arm: mach-omap2: voltage.c: Remove some unused functions
Date: Fri, 02 Jan 2015 22:22:49 +0100
Message-ID: <1495149.Vn5ZbzJ5yF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKXHbyPnTzOxWBBL0eiCNOPfF=htKpFRSt+R5h8o45ERp7zi1A@mail.gmail.com>
References: <1420131994-31636-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <3966855.LUXW4xbVYM@wuerfel> <CAKXHbyPnTzOxWBBL0eiCNOPfF=htKpFRSt+R5h8o45ERp7zi1A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:l+O01FFZ8sEh5nK+Q27AdgdDxVbf5+eZVJ1/HsebmLGUz1R62Ww
 Klo21UqpqJ59aoiaEArswRQRzPpeAVgOLUMr6Ot0EgPdp0b28yRwCyf0b9Zdwxs5CwWh3Jk
 EyV4bR8NYqhTsXxm+5/qd0SFSKPFUt3L/+ac+/Cy+IwID9s2+7i6YrpsG5PWMuAbX/vJGfr
 t2ir2i4G/Tdch2GOTd3Eg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2015 17:02:21 Rickard Strandqvist wrote:
> 2015-01-02 10:46 GMT+01:00 Arnd Bergmann <arnd@arndb.de>:
> > On Thursday 01 January 2015 18:06:34 Rickard Strandqvist wrote:
> >
> > You have correctly spotted the only place that references
> > voltdm_for_each_pwrdm
> > and changed the comment, but you failed to notice that it no longer makes
> > sense to call voltdm_add_pwrdm or keep the voltdm->pwrdm_list pointer
> > at all, so this function, and the associated list heads can all be removed
> > as well.
> >
> >         Arnd
> >
> 
> 
> Hi Arnd
> 
> Thanks for your reply.
> 
> I see what you mean, but you are aware that voltdm_add_pwrdm() also be
> called from:
> arch/arm/mach-omap2/powerdomain.c in _pwrdm_register()

Yes, that call needs to be removed as well of course.

> I have also removde the voltdm_for_each()

Ok, sounds good. That list of course has to stay though, so removing
_voltdm_register would be bad ;-)

	Arnd
