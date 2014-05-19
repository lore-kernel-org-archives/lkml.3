Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaESHcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 03:32:35 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:44448 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaESHcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 03:32:33 -0400
Message-ID: <1400484704.1464.4.camel@iivanov-dev>
Subject: Re: [PATCH 2/4] spi: qup: Correct selection of FIFO/Block mode
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Date: Mon, 19 May 2014 10:31:44 +0300
In-Reply-To: <1400016884-9568-3-git-send-email-agross@codeaurora.org>
References: <1400016884-9568-1-git-send-email-agross@codeaurora.org>
	 <1400016884-9568-3-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 16:34 -0500, Andy Gross wrote:
> This patch fixes the calculation for determining whether to use FIFO or BLOCK
> mode.

<snip>

> @@ -368,7 +368,7 @@ static int spi_qup_io_config(struct spi_device *spi, struct spi_transfer *xfer)
>  	n_words = xfer->len / w_size;
>  	controller->w_size = w_size;
>  
> -	if (n_words <= controller->in_fifo_sz) {
> +	if (n_words <= (controller->in_fifo_sz / sizeof(u32))) {

Wouldn't be better to divide by w_size? Probably will not make
too much difference, but..

>  		mode = QUP_IO_M_MODE_FIFO;

Regards,
Ivan

