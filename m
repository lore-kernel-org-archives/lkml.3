Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaLDVBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:01:12 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:48964 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaLDVBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:01:10 -0500
X-ME-Helo: beldin
X-ME-Date: Thu, 04 Dec 2014 22:01:08 +0100
X-ME-IP: 109.214.46.91
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Martin Oldfield <m@mjoldfield.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi/pxa2xx: Clear cur_chip pointer before starting next message
References: <1417425166-150374-1-git-send-email-mika.westerberg@linux.intel.com>
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 04 Dec 2014 22:01:06 +0100
In-Reply-To: <1417425166-150374-1-git-send-email-mika.westerberg@linux.intel.com>
	(Mika Westerberg's message of "Mon, 1 Dec 2014 11:12:46 +0200")
Message-ID: <87egsfyvsd.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mika Westerberg <mika.westerberg@linux.intel.com> writes:

> Once the current message is finished, the driver notifies SPI core about
> this by calling spi_finalize_current_message(). This function queues next
> message to be transferred. If there are more messages in the queue, it is
> possible that the driver is asked to transfer the next message at this
> point.
>
> When spi_finalize_current_message() returns the driver clears the
> drv_data->cur_chip pointer to NULL. The problem is that if the driver
> already started the next message clearing drv_data->cur_chip will cause
> NULL pointer dereference which crashes the kernel like:
..zip..
> Fix this by clearing drv_data->cur_chip before we call
> spi_finalize_current_message().

So with your change, we have :
  	drv_data->cur_chip = NULL;
	spi_finalize_current_message(drv_data->master);

In that case, if spi_finalize_current_message() queues another message, upon
this next message completion, won't giveback() be called, and dereference
cur_chip as well ?

Cheers.

--
Robert
