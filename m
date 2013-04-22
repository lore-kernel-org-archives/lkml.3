Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab3DVPS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:18:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62596 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263Ab3DVPSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:18:55 -0400
Date: Mon, 22 Apr 2013 16:18:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv2] arm: Preserve TPIDRURW on context switch
Message-ID: <20130422151836.GA15665@mudshark.cambridge.arm.com>
References: <517168BB.3070903@dawncrow.de>
 <20130422143616.GP14496@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130422143616.GP14496@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 03:36:16PM +0100, Russell King - ARM Linux wrote:
> On Fri, Apr 19, 2013 at 05:54:35PM +0200, André Hentschel wrote:
> > From: =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>
> > 
> > There are more and more applications coming to WinRT, Wine could support them,
> > but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
> > This register must be preserved per thread instead of being cleared.
> > 
> > Signed-off-by: André Hentschel <nerv@dawncrow.de>
> 
> This actually makes things less efficient all round, because you
> now use the value immediately after loading, which means it will cause
> pipeline stalls, certainly on older CPUs.
> 
> Could you please rework the patch to try avoiding soo many modifications
> to the way things have been done here?

copy_thread also needs updating so that the *register* value for the parent
is copied to the child, since the parent may have written the register
after the last context-switch, meaning that tp_value is out-of-date.

Will
