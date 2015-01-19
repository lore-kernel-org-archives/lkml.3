Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbbASUro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:47:44 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:53597 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbASUrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:47:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: David Daney <ddaney.cavm@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Vinita Gupta <vgupta@caviumnetworks.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] SATA: OCTEON: support SATA on OCTEON platform
Date: Mon, 19 Jan 2015 21:46:52 +0100
Message-ID: <1657896.cG5R2xLFfX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqKq22K3kk7m09J1GZn9xXB+0tCUe75u3x+S3oWC0kyDcw@mail.gmail.com>
References: <1421681040-3392-1-git-send-email-aleksey.makarov@auriga.com> <54BD580C.6030701@gmail.com> <CAL_JsqKq22K3kk7m09J1GZn9xXB+0tCUe75u3x+S3oWC0kyDcw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:540wG67se4TLuWNRSqikIKpRuD5km1mHJq7AiuoZIGXOELbhKak
 tZBvHs19dh+jh6nRbZe6BBKT4aBlx/CMO6oc1IfQTI30M66nQqTiHiI5N1JYJUNvxUHS0jD
 ru66g788qlVWH1VA90owcaPGUNmpaY+AVuH4j3A7jAzHmPgVpJ9tG5L/oeopcAQw0WyUicG
 p+FEjRhZh/3enC2UCZMIw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2015 14:30:22 Rob Herring wrote:
> On Mon, Jan 19, 2015 at 1:16 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> > On 01/19/2015 07:43 AM, Mark Rutland wrote:
> >>
> >> On Mon, Jan 19, 2015 at 03:23:58PM +0000, Aleksey Makarov wrote:
> >>>
> >>> The OCTEON SATA controller is currently found on cn71XX devices.
> 
> [...]
> 
> >>> +
> >>> +       /* Set a good dma_mask */
> >>> +       pdev->dev.coherent_dma_mask = DMA_BIT_MASK(64);
> >>> +       pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> >>
> >>
> >> I thought a dma-ranges property in the DT could be used to set up the
> >> DMA mask appropriately?
> >
> >
> > The DT contains no dma-ranges property, and we know a priori, that it should
> > be 64-bits.
> 
> Neither this code nor dma-ranges should be necessary. The AHCI core
> code will set the mask to 32 or 64 bits based on the AHCI Capabilities
> register.

You should however have a dma-ranges property in the parent bus of the
device that contains the allowed range for DMA. The current dma_set_mask
function is broken and will accept whatever a device driver asks for,
and we need to fix this so masks larger than what is specified in dma-ranges
are rejected.

	Arnd
