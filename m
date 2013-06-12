Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab3FLPGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:06:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58808 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3FLPGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:06:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] dma-mapping: Add BUG_ON for uninitialized dma_ops
Date: Wed, 12 Jun 2013 17:06:39 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        "Linux-Arch" <linux-arch@vger.kernel.org>
References: <f35c5051a207b0a117f2fff27365d0ea892d1610.1370263476.git.michal.simek@xilinx.com> <51B703D7.8050804@samsung.com> <1370958858.2286.5.camel@dabdike>
In-Reply-To: <1370958858.2286.5.camel@dabdike>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306121706.39368.arnd@arndb.de>
X-Provags-ID: V02:K0:6hRKbKYtF84mfpmsQWufNnXbSZBZUMP3LW97NRAo/LK
 CfoUI4lWWBEdNd2uQx0Z7FV3Z7Bd3dd2wcLLyBxJE2ThIWPtFt
 gwX57f+mtWoSlGZIejLa5G6Px6W2wxDpY6kQZffO0v7uuPLmYi
 RBMkO9kjVWPqSZ12PUAX8eRhn7zh7+IrLaTuWwiNRuoziSscT1
 g3C+m3U2ZiCDzbEV1YpdP/QvPw50PeDH+S1yQOYjsJ2R4RHI80
 DM+WYWY2wXVFGNGjR6fJLUZE9DRv9i1ri07evzdKWlMCoR2FdU
 NqDRmxxRRockCkkPh10hxpv5oeatJ9xpfHZIEHgBF3KyI0PgeC
 dn0s5nC6niW4z3J3TCN0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 June 2013, James Bottomley wrote:
> Really, no, it's not a good idea at all.  It invites tons of patches
> littering the code with BUG_ONs where we might possibly get a NULL
> dereference.  All it does is add extra instructions to a code path for
> no actual benefit.
> 
> If you can answer the question: what more information does the BUG_ON
> give you than the NULL deref Oops would not? then it might be
> reasonable.

The question is if a user can trigger the NULL dereference intentionally,
in which case they might get the kernel to jump into a  user-provided
buffer.

	Arnd
