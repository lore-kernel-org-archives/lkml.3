Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3LLRNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:13:42 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55021 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3LLRNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:13:41 -0500
Date: Thu, 12 Dec 2013 17:13:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iamjoonsoo.kim@lge.com
Subject: Re: possible regression on 3.13 when calling flush_dcache_page
Message-ID: <20131212171322.GT4360@n2100.arm.linux.org.uk>
References: <20131212143149.GI12099@ldesroches-Latitude-E6320>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212143149.GI12099@ldesroches-Latitude-E6320>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 03:31:50PM +0100, Ludovic Desroches wrote:
> I'll investigate on atmel-mci driver side but if someone has also this
> issue or see what is wrong in the driver, please tell me all about it.

I'm not entirely sure what's causing this, but calling flush_dcache_page()
from an IRQ isn't the best idea, as one of its side effects will be to
unmask IRQs at the CPU.

BTW, the faulting function seems to have been removed in more recent
kernels.
