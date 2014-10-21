Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaJUI4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:56:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:57750 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaJUI4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:56:10 -0400
Date: Tue, 21 Oct 2014 10:56:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Kelly <martin@martingkelly.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, rientjes@google.com,
        david.vrabel@citrix.com, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH v2] x86, e820: panic on sanitizing invalid memory map
In-Reply-To: <1413859062-26594-1-git-send-email-martin@martingkelly.com>
Message-ID: <alpine.DEB.2.11.1410211043150.5308@nanos>
References: <1413859062-26594-1-git-send-email-martin@martingkelly.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014, Martin Kelly wrote:

> sanitize_e820_map returns two possible values:
> -1: Returned when either the provided memory map has length 1 (ok) or
>     when the provided memory map is invalid (not ok).
> 0:  Returned when the memory map was correctly sanitized.
> 
> In addition, most code ignores the returned value, and none actually
> handles it (except possibly by panicking).

There are reasons WHY some code does ignore it.
 
> This patch changes the behavior so that sanitize_e820_map is a void
> function. When the provided memory map has length 1 or it is sanitized
> (both ok cases), it returns nothing. If the provided memory map is
> invalid, then it panics.

So you break wilfully default_machine_specific_memory_setup() and
probably some other places. Are you sure about that?

Thanks,

	tglx
