Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaL1Mv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 07:51:29 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:55615 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaL1Mv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 07:51:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dmitry Safonov <d.safonov@partner.samsung.com>, linux-mm@kvack.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Dyasly Sergey <s.dyasly@samsung.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <JBottomley@parallels.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH RESEND] mm: vmalloc: remove ioremap align constraint
Date: Tue, 23 Dec 2014 21:58:49 +0100
Message-ID: <11656044.WGcPr1b8t8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1419328813-2211-1-git-send-email-d.safonov@partner.samsung.com>
References: <1419328813-2211-1-git-send-email-d.safonov@partner.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:dLD1iZvKUgU5tNIq1fHIsiRz1IGHbl6IrGZB1EutZM/luYP5itC
 lI1GUK9WvBzaZObuxVWsXCp6bc0XR61jVFNyyyP3wpdhocLHHgHX6ZXfGMvaAlyfnRwa+WU
 3CRzNmol7QsrlZ7fP6k9EfDuJ0RTbU4hbTI9oeKmvlSCgGmQVCWkZTwp7geGCuiAyiEewog
 OgfMXF7pwWQfJVlsYGEKg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 December 2014 13:00:13 Dmitry Safonov wrote:
> ioremap uses __get_vm_area_node which sets alignment to fls of requested size.
> I couldn't find any reason for such big align. Does it decrease TLB misses?
> I tested it on custom ARM board with 200+ Mb of ioremap and it works.
> What am I missing?

The alignment was originally introduced in this commit:

commit ff0daca525dde796382b9ccd563f169df2571211
Author: Russell King <rmk@dyn-67.arm.linux.org.uk>
Date:   Thu Jun 29 20:17:15 2006 +0100

    [ARM] Add section support to ioremap
    
    Allow section mappings to be setup using ioremap() and torn down
    with iounmap().  This requires additional support in the MM
    context switch to ensure that mappings are properly synchronised
    when mapped in.
    
    Based an original implementation by Deepak Saxena, reworked and
    ARMv6 support added by rmk.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

and then later extended to 16MB supersection mappings, which indeed
is used to reduce TLB pressure.

I don't see any downsides to it, why change it?

	Arnd
