Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbaJaQzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:55:20 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:53096
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337AbaJaQzT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:55:19 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: comedi: icp_multi: correct insn_bits returned
 data for DO
Thread-Topic: [PATCH] staging: comedi: icp_multi: correct insn_bits returned
 data for DO
Thread-Index: AQHP9ReL/9p66cljdUa8MyiBRG9D+pxKbD8A
Date: Fri, 31 Oct 2014 16:55:17 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D882601A797@P3PWEX4MB008.ex4.secureserver.net>
References: <1414765947-15464-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1414765947-15464-1-git-send-email-abbotti@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 31, 2014 7:32 AM, Ian Abbott wrote:
> For some unfathomable reason, the Comedi `insn_bits` handler for the
> digital output subdevice (`icp_multi_insn_bits_do()`) writes the digital
> output register and reads back the unrelated digital input register.
> Read back the current state of the outputs (held in `s->state`) instead.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/drivers/icp_multi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
> index f4e1c1c..db744c8 100644
> --- a/drivers/staging/comedi/drivers/icp_multi.c
> +++ b/drivers/staging/comedi/drivers/icp_multi.c
> @@ -53,7 +53,7 @@ Configuration options: not applicable, uses PCI auto config
>  #define ICP_MULTI_AI		2	/* R:   Analogue input data */
>  #define ICP_MULTI_DAC_CSR	4	/* R/W: DAC command/status register */
>  #define ICP_MULTI_AO		6	/* R/W: Analogue output data */
> -#define ICP_MULTI_DI		8	/* R/W: Digital inouts */
> +#define ICP_MULTI_DI		8	/* R/W: Digital inputs */
>  #define ICP_MULTI_DO		0x0A	/* R/W: Digital outputs */
>  #define ICP_MULTI_INT_EN	0x0C	/* R/W: Interrupt enable register */
>  #define ICP_MULTI_INT_STAT	0x0E	/* R/W: Interrupt status register */
> @@ -319,7 +319,7 @@ static int icp_multi_insn_bits_do(struct comedi_device *dev,
>  	if (comedi_dio_update_state(s, data))
>  		writew(s->state, dev->mmio + ICP_MULTI_DO);
>  
> -	data[1] = readw(dev->mmio + ICP_MULTI_DI);
> +	data[1] = s->state;
>  
>  	return insn->n;
>  }

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

