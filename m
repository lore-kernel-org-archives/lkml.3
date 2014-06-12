Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbaFLKE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:04:26 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:42528 "EHLO
	vsp-authed-04-02.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933128AbaFLKEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:04:24 -0400
Message-ID: <53997AF6.1040003@gaisler.com>
Date: Thu, 12 Jun 2014 12:03:34 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: nyushchenko@dev.rtsoft.ru, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        sparclinux@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 00/21] add and use devm_irq_of_parse_and_map()
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-04 13:13, nyushchenko@dev.rtsoft.ru wrote:
> Currently many device tree aware drivers use irq_of_parse_and_map() to get
> IRQ number and then devm_request_irq() to set up IRQ handler.
>
> This causes a problem for exit path and for error paths: undo action for
> irq_of_parse_and_map() is irq_dispose_mapping() that must not be called
> while IRQ handler is defined, but devres moves free_irq() out of driver
> so driver does not have safe place to call irq_dispose_mapping().
>
> So many drivers do not call irq_dispose_mapping() at all, others call it
> while IRQ handler is defined (which is incorrect and causes error messages
> in logs), even others refuse to use devres for managing IRQ handlers.
>
> This patchset adds devres version of irq_of_parse_and_map(), and updates
> in-tree users of both devres and irq_of_parse_and_map() to use
> devm_irq_of_parse_and_map() instead.


SPARC does not use OF_IRQ and has a different implementation of 
irq_of_parse_and_map than the one in drivers/of/irq.c. All code 
converted from irq_of_parse_and_map to devm_irq_of_parse_and_map in this 
patch set will be unlinkable for SPARC. This includes SPI in general and 
many drivers that are used for SPARC (of which several are currently 
only used on SPARC platforms).

Best regards,
Andreas Larsson
