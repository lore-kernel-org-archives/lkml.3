Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab3CZU4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:56:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:59136 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3CZU4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:56:16 -0400
Date: Tue, 26 Mar 2013 21:56:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, cpa: Cleanup split_large_page and its callee
In-Reply-To: <1363886217-24703-1-git-send-email-bp@alien8.de>
Message-ID: <alpine.LFD.2.02.1303262155460.22263@ionos>
References: <1363886217-24703-1-git-send-email-bp@alien8.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Borislav Petkov wrote:

> From: Borislav Petkov <bp@suse.de>
> 
> So basically we're generating the pte_t * from a struct page and we're
> handing it down to the __split_large_page internal version which then
> goes and gets back struct page * from it because it needs it.
> 
> Change the caller to hand down struct page * directly and the callee can
> compute the pte_t itself.
> 
> Net save is one virt_to_page() call and simpler code. While at it, make
> __split_large_page static.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
