Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab3BWRfJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 12:35:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43245 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3BWRfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 12:35:06 -0500
Date: Sat, 23 Feb 2013 20:34:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Kumar Amit Mehta <gmate.amit@gmail.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: comedi: drivers: usbduxfast.c: fix for DMA
 buffers on stack
Message-ID: <20130223173442.GL9138@mwanda>
References: <1361556450-32572-1-git-send-email-gmate.amit@gmail.com>
 <5127BFDB.4010608@bfs.de>
 <20130222190644.GA16011@kroah.com>
 <5128E76F.1000607@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5128E76F.1000607@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 04:59:43PM +0100, walter harms wrote:
> >> or is it possible to pass one byte
> >> in a register ? (aka char/int) without allocating ?
> > 
> > Nope, the USB host controllers must be able to DMA to this memory
> > location, so you have to allocate it dynamically, sorry.
> > 
> > thanks,
> 
> thx for clarification.
> 
> @Kumar Amit Mehta:
> Would you mind to add this as comment ? Allocating one byte does not
> look clever so maybe will come up with the idea of changing that.
> 

That can't happen.  The reason is already recorded in the git
history.  Greg and Ian know that DMA to stack memory doesn't work.
Most maintainers know about that.  If someone changed it back then
Fengguang would send an automatic email about it as soon as it was
committed to a public git tree.

regards,
dan carpenter
