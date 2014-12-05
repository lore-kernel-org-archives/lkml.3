Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbaLEWaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:30:03 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:51389 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLEWaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:30:02 -0500
MIME-Version: 1.0
In-Reply-To: <1417808133-20719-3-git-send-email-grmoore@opensource.altera.com>
References: <1417808133-20719-1-git-send-email-grmoore@opensource.altera.com>
	<1417808133-20719-3-git-send-email-grmoore@opensource.altera.com>
Date: Fri, 5 Dec 2014 23:30:00 +0100
Message-ID: <CACna6ry0WBwcqH74sub-C=e0oGsPEoqXZ4O7uAwGcJC9Zc2zJw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mtd: spi-nor: Add driver for Cadence Quad SPI Flash Controller.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Graham Moore <grmoore@opensource.altera.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Alan Tull <atull@opensource.altera.com>,
        Yves Vandervennet <yvanderv@opensource.altera.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2014 at 20:35, Graham Moore <grmoore@opensource.altera.com> wrote:
> +               if (of_modalias_node(np, modalias, sizeof(modalias)) < 0)
> +                       goto probe_failed;
> +
> +               ret = spi_nor_scan(nor, modalias, SPI_NOR_QUAD);
> +               if (ret)
> +                       goto probe_failed;
> (...)
> +
> +static struct of_device_id cqspi_dt_ids[] = {
> +       {.compatible = "cdns,qspi-nor",},
> +       { /* end of table */ }
> +};

AFAIU of_modalias_node will give you "qspi-nor" string. Second
argument passed to the spi_nor_scan is a chip name you expect on the
device. Of course passing "qspi-nor" (if I'm right about
of_modalias_node) doesn't make any sense.

Since my commit
mtd: spi-nor: allow NULL as chip name and try to auto detect it
second argument is optional.

Can you simply pass NULL instead of modalias?

-- 
Rafał
