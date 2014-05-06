Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbaEFPpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:45:42 -0400
Received: from mail-bl2on0131.outbound.protection.outlook.com ([65.55.169.131]:13216
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755148AbaEFPpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:45:40 -0400
Message-ID: <1399390979.11533.6.camel@linux-builds1>
Subject: Re: [PATCHv3 3/3] edac: altera: Add EDAC support for Altera SDRAM
From: Dinh Nguyen <dinguyen@altera.com>
To: Thor Thayer <tthayer@altera.com>
CC: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>
Date: Tue, 6 May 2014 10:42:59 -0500
In-Reply-To: <1399330337-16748-4-git-send-email-tthayer@altera.com>
References: <1399330337-16748-1-git-send-email-tthayer@altera.com>
	 <1399330337-16748-4-git-send-email-tthayer@altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(24454002)(51704005)(199002)(377424004)(189002)(47776003)(44976005)(83322001)(33716001)(79102001)(6806004)(19580405001)(50466002)(19580395003)(77982001)(46102001)(20776003)(50986999)(84676001)(87936001)(97736001)(99396002)(76176999)(87286001)(74662001)(77156001)(31966008)(2009001)(33646001)(81542001)(80022001)(92566001)(88136002)(4396001)(62966002)(89996001)(92726001)(81342001)(23676002)(50226001)(86362001)(83072002)(74502001)(85852003)(76482001)(93916002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2FFO11HUB030;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:A85DFFE5.2C3BA4D8.13751FCF.9C77F279.20205;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0203C93D51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 17:52 -0500, Thor Thayer wrote:
> From: Thor Thayer <tthayer@altera.com>
> 
> ---
> v2: Use the SDRAM controller registers to calculate memory size
>     instead of the Device Tree. Update To & Cc list. Add maintainer
>     information.
> 
> v3: EDAC driver cleanup based on comments from Mailing list.
> 
> Signed-off-by: Thor Thayer <tthayer@altera.com>
> ---
>  MAINTAINERS                |    5 +
>  drivers/edac/Kconfig       |    9 +
>  drivers/edac/Makefile      |    2 +
>  drivers/edac/altera_edac.c |  411 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 427 insertions(+)
>  create mode 100644 drivers/edac/altera_edac.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e67ea24..ecd1277 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1290,6 +1290,11 @@ M:	Dinh Nguyen <dinguyen@altera.com>
>  S:	Maintained
>  F:	drivers/clk/socfpga/
>  
> +ARM/SOCFPGA SDRAM EDAC SUPPORT
> +M:	Thor Thayer <tthayer@altera.com>
> +S:	Maintained
> +F:	drivers/edac/altera_edac.c
> +
>  ARM/STI ARCHITECTURE
>  M:	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
>  M:	Maxime Coquelin <maxime.coquelin@st.com>
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 878f090..4f4d379 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -368,4 +368,13 @@ config EDAC_OCTEON_PCI
>  	  Support for error detection and correction on the
>  	  Cavium Octeon family of SOCs.
>  
> +config EDAC_ALTERA_MC
> +	bool "Altera SDRAM Memory Controller EDAC"

Can this be tristate?

Dinh

