Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab3BFWzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:55:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36992 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab3BFWzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:55:04 -0500
Date: Wed, 6 Feb 2013 22:51:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>
Cc: linux-arch@vger.kernel.org, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] arm: Preserve TPIDRURW on context switch
Message-ID: <20130206225150.GL17833@n2100.arm.linux.org.uk>
References: <5112DC7E.4020108@dawncrow.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5112DC7E.4020108@dawncrow.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 11:43:10PM +0100, André Hentschel wrote:
> There are more and more applications coming to WinRT, Wine could support them,
> but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
> This register must be preserved per thread instead of being cleared.

I'd prefer this was done a little more sensitively to those CPUs where
loads/stores are expensive, namely:

> +
> +	@ preserve TPIDRURW register state
> +	get_tls2	r3, r4, r5
> +	str	r3, [r1, #TI_TP2_VALUE]
> +	ldr	r3, [r2, #TI_TP2_VALUE]
> +	set_tls2	r3, r4, r5

those two loads/stores get omitted from the thread switching if the CPU
doesn't support it.  Do you think that's something you could do?
