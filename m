Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3DVOgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:36:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36372 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab3DVOgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:36:38 -0400
Date: Mon, 22 Apr 2013 15:36:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>
Cc: linux-arch@vger.kernel.org, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCHv2] arm: Preserve TPIDRURW on context switch
Message-ID: <20130422143616.GP14496@n2100.arm.linux.org.uk>
References: <517168BB.3070903@dawncrow.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <517168BB.3070903@dawncrow.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 05:54:35PM +0200, André Hentschel wrote:
> From: =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>
> 
> There are more and more applications coming to WinRT, Wine could support them,
> but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
> This register must be preserved per thread instead of being cleared.
> 
> Signed-off-by: André Hentschel <nerv@dawncrow.de>

This actually makes things less efficient all round, because you
now use the value immediately after loading, which means it will cause
pipeline stalls, certainly on older CPUs.

Could you please rework the patch to try avoiding soo many modifications
to the way things have been done here?
