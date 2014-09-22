Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaIVHMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:12:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:46321 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaIVHMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:12:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,570,1406617200"; 
   d="scan'208";a="479110116"
Date: Mon, 22 Sep 2014 10:12:11 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCHv2] serial: 8250: Add Quark X1000 to 8250 PCI driver
Message-ID: <20140922071211.GA26114@xps8300>
References: <1411112629-3238-1-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411112629-3238-1-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Sep 19, 2014 at 08:43:49AM +0100, Bryan O'Donoghue wrote:
> Adds PCI identifier for the X1000
> Adds clocking and register size and register shift

I would be more interested in the details about the Quart UART, like
how many ports you got, maybe the clock frequency etc. then about the
actual steps the you are taking in the patch.


> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
> ---
>  drivers/tty/serial/8250/8250_pci.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
> index 61830b1..5e72959 100644
> --- a/drivers/tty/serial/8250/8250_pci.c
> +++ b/drivers/tty/serial/8250/8250_pci.c
> @@ -1481,6 +1481,19 @@ byt_serial_setup(struct serial_private *priv,
>  	return ret;
>  }
>  
> +#define PCI_DEVICE_ID_INTEL_QRK_UART	0x0936
> +
> +static int
> +pci_intel_qrk_setup(struct serial_private *priv,
> +		const struct pciserial_board *board,
> +		struct uart_8250_port *port, int idx)
> +{
> +	unsigned int bar, offset = board->first_offset;
> +
> +	bar = FL_GET_BASE(board->flags);
> +
> +	return setup_port(priv, port, bar, offset, board->reg_shift);
> +}

You don't need to add this. Just use pci_default_setup.


Thanks,

-- 
heikki
