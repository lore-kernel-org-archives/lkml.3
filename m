Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaIDKCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:02:00 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50666 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaIDKB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:01:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Andrew Pinski <apinski@cavium.com>, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Subject: Re: [PATCH 24/24] Add documentation about ARM64 ILP32 ABI
Date: Thu, 04 Sep 2014 12:01:52 +0200
Message-ID: <4031586.MjMM3BtNgn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409779158-30963-25-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com> <1409779158-30963-25-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gfbSkqXEqO09ZOZ5IJU7S6e09L2/Cen/pT49KtaJVO3
 abMsPih+Kr2tgSST+TxnrEerhXzEmSm/MTsEYM6z8Wrrfk3Scb
 mqVQyGpLeRESv1bOK5Kaf+ZnZY/PEPt+R/OloWbQBIZdfA24C7
 pQ6IfhyisVm+oqlQGsgJLTZBz2YfCjE9/CLn01CTOT+u+/ogdt
 nLHCbQCrAGepCJQQxHXTMxDWfSgHcuVIn5c1ZM809m+gzNPrR1
 2D//ibo7Zvrqh1n3RxoHqtgzvIDssMipkkVUonWFdowq1UXXL9
 AhetWp40n27AOgt3VgCDMNhwL+K7Bzk7wJrEu82G8K65ofRm3H
 W3yFPmLZo5zGXIX+qeno=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2014 14:19:18 Andrew Pinski wrote:
> +This document describes the ILP32 syscall ABI and where it differs
> +from the generic linux syscall interface.
> +ILP32 sets __kernel_long_t and __kernel_ulong_t both to 64bit
> +(long long).  This effects the following types:
> +* time_t: unsigned long long
> +* clock_t: unsigned long long
> +* fsword_t: long long
> +* suseconds_t: long long
> +* swblk_t: long long
> +* fd_mask_t: long long

What about data structures derived from these? I'm worried that
some of them (in particular time_t) leak into ioctl interfaces
when they are getting included in some other data structure that
is used as an ioctl argument.

Do you have a list of which data structures change based on the
scalar type changes?

	Arnd
