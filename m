Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3CEJgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:36:21 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:64417 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3CEJgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:36:15 -0500
Date: Tue, 5 Mar 2013 17:36:12 +0800 (HKT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ARM: mm: disable kmap_high_get() for SMP
In-Reply-To: <1362372667-953-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.LFD.2.03.1303051642110.28820@syhkavp.arg>
References: <1362372667-953-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013, Joonsoo Kim wrote:

> With SMP and enabling kmap_high_get(), it makes users of kmap_atomic()
> sequential ordered, because kmap_high_get() use global kmap_lock().
> It is not welcome situation, so turn off this optimization for SMP.

I'm not sure I understand the problem.

The lock taken by kmap_high_get() is released right away before that 
function returns and therefore this is not actually serializing 
anything.


Nicolas
