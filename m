Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaBUTwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:52:01 -0500
Received: from www.linutronix.de ([62.245.132.108]:43489 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbaBUTv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:51:59 -0500
Date: Fri, 21 Feb 2014 20:51:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexandre Bounine <alexandre.bounine@idt.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Xiaotian Feng <xtfeng@gmail.com>, Mike Galbraith <bitbucket@online.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] rapidio/tsi721: fix tasklet termination in dma channel
 release
In-Reply-To: <1393010358-6837-1-git-send-email-alexandre.bounine@idt.com>
Message-ID: <alpine.DEB.2.02.1402212047080.21251@ionos.tec.linutronix.de>
References: <1393010358-6837-1-git-send-email-alexandre.bounine@idt.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014, Alexandre Bounine wrote:
> This patch is a modification of the patch originally proposed
> by Xiaotian Feng <xtfeng@gmail.com>: https://lkml.org/lkml/2012/11/5/413
> This new version disables DMA channel interrupts and ensures that the tasklet
> wil not be scheduled again before calling tasklet_kill().
> 
> Unfortunately the updated patch was not released at that time due to planned
> rework of Tsi721 mport driver to use threaded interrupts (which has yet to
> happen).
> Recently the issue was reported again: https://lkml.org/lkml/2014/2/19/762.
> 
> Description from the original Xiaotian's patch:
> 
> "Some drivers use tasklet_disable in device remove/release process, 
> tasklet_disable will inc tasklet->count and return. If the tasklet is 
> not handled yet under some softirq pressure, the tasklet will be 
> placed on the tasklet_vec, never have a chance to be excuted. This 
> might lead to a heavy loaded ksoftirqd, wakeup with pending_softirq, 
> but tasklet is disabled. tasklet_kill should be used in this case."
> 
> This patch is applicable to kernel versions starting from v3.5.
> 
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> Cc: Matt Porter <mporter@kernel.crashing.org>
> Cc: Xiaotian Feng <xtfeng@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mike Galbraith <bitbucket@online.de>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
