Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3CZREu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:04:50 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:52055 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3CZREs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:04:48 -0400
Message-ID: <1364317476.3866.4.camel@thor.lan>
Subject: Re: [PATCH] firewire: Enable physical DMA above 4GB
From: Peter Hurley <peter@hurleysoftware.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 13:04:36 -0400
In-Reply-To: <5151C90A.5010108@ladisch.de>
References: <1364307734-27709-1-git-send-email-peter@hurleysoftware.com>
	 <5151C90A.5010108@ladisch.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 17:12 +0100, Clemens Ladisch wrote:
> Peter Hurley wrote:
> > Quadlet reads to memory above 4GB is painfully slow when serviced
> > by the AR DMA context. In addition, the CPU(s) may be locked-up,
> > preventing any transfer at all.
> 
> Using physical DMA prevents the use of that address space for software
> address handlers, so you have adjust the low_memory_region start in
> core-transaction.c.

Right, thanks for pointing that out.

> > Write the PhyUpperBound register with the end-of-memory value. If
> > end-of-memory is beyond the OHCI limit of 0x0000ffff00000000,
> > clamp to that value.
> 
> You will have to lower this limit; there are protcols that assume that
> addresses like 0xecc000000000 are available for software.

Maybe 0x0000e80000000000 is a better maximum upper bound?

Regards,
Peter Hurley

