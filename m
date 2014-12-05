Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaLESgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:36:50 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:29891 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLESgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:36:49 -0500
X-ME-Helo: beldin
X-ME-Date: Fri, 05 Dec 2014 19:36:48 +0100
X-ME-IP: 109.214.46.91
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Martin Oldfield <m@mjoldfield.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi/pxa2xx: Clear cur_chip pointer before starting next message
References: <1417425166-150374-1-git-send-email-mika.westerberg@linux.intel.com>
	<87egsfyvsd.fsf@free.fr> <20141205082429.GF1306@lahna.fi.intel.com>
X-URL: http://belgarath.falguerolles.org/
Date: Fri, 05 Dec 2014 19:36:41 +0100
In-Reply-To: <20141205082429.GF1306@lahna.fi.intel.com> (Mika Westerberg's
	message of "Fri, 5 Dec 2014 10:24:29 +0200")
Message-ID: <87r3wex7t2.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mika Westerberg <mika.westerberg@linux.intel.com> writes:

> On Thu, Dec 04, 2014 at 10:01:06PM +0100, Robert Jarzmik wrote:
>> So with your change, we have :
>>   	drv_data->cur_chip = NULL;
>> 	spi_finalize_current_message(drv_data->master);
>> 
>> In that case, if spi_finalize_current_message() queues another message, upon
>> this next message completion, won't giveback() be called, and dereference
>> cur_chip as well ?
>
> When the next message is started pxa2xx_spi_transfer_one_message() gets
> called and that will set cur_chip again.

Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

-- 
Robert
