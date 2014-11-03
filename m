Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaKCRO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:14:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:54321 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaKCROv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:14:51 -0500
Date: Mon, 3 Nov 2014 18:14:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Toshi Kani <toshi.kani@hp.com>
cc: hpa@zytor.com, mingo@redhat.com, akpm@linux-foundation.org, arnd@arndb.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br,
        yigal@plexistor.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v4 1/7] x86, mm, pat: Set WT to PA7 slot of PAT MSR
In-Reply-To: <1414450545-14028-2-git-send-email-toshi.kani@hp.com>
Message-ID: <alpine.DEB.2.11.1411031812390.5308@nanos>
References: <1414450545-14028-1-git-send-email-toshi.kani@hp.com> <1414450545-14028-2-git-send-email-toshi.kani@hp.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Toshi Kani wrote:
> +	} else {
> +		/*
> +		 * PAT full support. WT is set to slot 7, which minimizes
> +		 * the risk of using the PAT bit as slot 3 is UC and is
> +		 * currently unused. Slot 4 should remain as reserved.

This comment makes no sense. What minimizes which risk and what has
this to do with slot 3 and slot 4?

> +		 *
> +		 *  PTE encoding used in Linux:
> +		 *      PAT
> +		 *      |PCD
> +		 *      ||PWT  PAT
> +		 *      |||    slot
> +		 *      000    0    WB : _PAGE_CACHE_MODE_WB
> +		 *      001    1    WC : _PAGE_CACHE_MODE_WC
> +		 *      010    2    UC-: _PAGE_CACHE_MODE_UC_MINUS
> +		 *      011    3    UC : _PAGE_CACHE_MODE_UC
> +		 *      100    4    <reserved>
> +		 *      101    5    <reserved>
> +		 *      110    6    <reserved>

Well, they are still mapped to WB/WC/UC_MINUS ....

> +		 *      111    7    WT : _PAGE_CACHE_MODE_WT
> +		 */
> +		pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, UC) |
> +		      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, WT);
> +	}

Thanks,

	tglx
