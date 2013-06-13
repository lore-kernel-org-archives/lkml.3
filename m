Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab3FMNot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:44:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42644 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab3FMNoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:44:46 -0400
Date: Thu, 13 Jun 2013 14:43:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, linux-arm-kernel@lists.infradead.org,
        linux@maxim.org.za, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Change the internal SRAM memory type
	MT_MEMORY_NONCACHED
Message-ID: <20130613134342.GE18614@n2100.arm.linux.org.uk>
References: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com> <1370657863-8725-1-git-send-email-wenyou.yang@atmel.com> <51B9C6FE.7000302@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B9C6FE.7000302@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 03:19:58PM +0200, Nicolas Ferre wrote:
> On 08/06/2013 04:17, Wenyou Yang :
>> Because MT_DEVICE is not executable in armv7, we change
>> the internal SRAM memory type to MT_MEMORY_NONCACHED.
>> As it seems that caching this internal SRAM memory is not necessary,
>> we chose the this memory type.
>>
>> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>
> But Russell, can we have your advice on this as you made us re-think  
> about that during previous patch discussion?

I think this is fine - using MT_MEMORY_NONCACHED gets you a memory-like
mapping instead of a strongly ordered or device mapping, but without
caching issues, which is what you want here.
