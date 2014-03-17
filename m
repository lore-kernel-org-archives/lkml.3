Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958AbaCQMPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:15:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:61820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbaCQMPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:15:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Girish K S <ks.giri@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, s-anna@ti.com, jassisinghbrar@gmail.com,
        ilho215.lee@samsung.com
Subject: Re: [PATCH 2/2] arm64: dts: exynos: added mailbox node
Date: Mon, 17 Mar 2014 13:15:35 +0100
Message-ID: <5346848.pBsh8NcQja@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1395057839-23871-3-git-send-email-ks.giri@samsung.com>
References: <1395057839-23871-1-git-send-email-ks.giri@samsung.com> <1395057839-23871-3-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:miuDsqKm8nFBAIolGNcF+xCZiVzJ0Ny0iBZZs/X9nmL
 yXBgide5/Cg5kl0OGjyRl6P9ob0LSTOrFCXaHEygvu3lBdjz5W
 dBqZP4B3XYsN69FGho1xjF5J8eTu+cvAz4AKf25aLjNlQdV6pF
 gQfw9miF1VbOhUe44mM/RZ9WjQr3nULRKwxSLxHq8gKD6cKvMb
 CpxgPMH/w8NxssvsDDDAIMgoibGX4cXLX/UZfeQxtqzqJmWHml
 X3z3hXF41RPUF3Lsmh7i9ConCrF4Nx/5c+YYrGFbiNpMvgfNT0
 8AUYoUWgY6MYJaMdCxegAVW5R/Gj7u1SPpA1gr01tzAq2IkrW6
 8jJa5iIWCMIbIAC9wz2c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2014 17:33:59 Girish K S wrote:
> +Samsung Mailbox Driver
> +
> +Required properties:
> +- compatible:          Should be one of the following,
> +                           "samsung,gh7-mailbox" for
> +                               Samsung GH7 SoC series
> +                           "samsung,exynos-mailbox" for
> +                               exynosx SoC series
> +- reg:                 Contains the mailbox register address range (base address
> +                       and length)
> +- interrupts:          Contains the interrupt information for the mailbox
> +                       device.
> +- samsung,mbox-names:  Array of the names of the mailboxes
> 

I think we should not allow new mailbox drivers that don't conform to
the framework that is currently under discussion. In particular, this
means don't do a "samsung,mbox-names" property. The current consensus
seems to be to have a #mbox-cells" property that allows to pass extra
parameters from the client driver, and uses an "mboxes" property
to reference the mailbox provided.

It would be good if you follow up for the subsystem discussion and
ensure it gets merged in time, and supports all the use cases you are
interested in. The interface is not entirely nailed down yet, so
it's a good time to contribute. However, I can already promise that
it won't use matching by strings.

	Arnd
