Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3A3KEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:04:44 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:40649 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752651Ab3A3KEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:04:42 -0500
Message-ID: <5108F031.1010005@gaisler.com>
Date: Wed, 30 Jan 2013 11:04:33 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        linux-kernel@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, software@gaisler.com
Subject: Re: [PATCH] spi: spi-fsl-spi: Make spi-fsl-spi usable in cpu mode
 outside of FSL SOC environments and add a grlib variant normally running
 on sparc
References: <1356711368-10437-1-git-send-email-andreas@gaisler.com>
In-Reply-To: <1356711368-10437-1-git-send-email-andreas@gaisler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-28 17:16, Andreas Larsson wrote:
> This makes the cpu mode of the driver available outside of an FSL SOC
> and even powerpc environment. This is accomplished by putting things
> regarding fsl specific code and to cpm specific code within ifdefs.
>
> Furthermore, this adds support for the mostly register-compatible
> SPICTRL core from the GRLIB VHDL IP core library normally running on
> sparc. A different entry in of_fsl_spi_match matches this core and
> indicates a different hardware type that is used to set up different
> function pointers and special cases. The fetching of irq is changed to
> work under sparc as well.
>
> The GRLIB core operates in cpu mode and from the driver's point of view
> the important differences are that the number of bits per word might be
> limited and that there might be native chipselects selected via the
> added slvsel register. These differences if present are indicated by an
> added capabilities register.
>
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Any comments anyone?

This patch takes "Approach A" discussed and supported in 
http://sourceforge.net/mailarchive/message.php?msg_id=30131080

Cheers,
Andreas Larsson

