Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3EQUfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 16:35:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55298 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755756Ab3EQUfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 16:35:24 -0400
Message-ID: <1368822923.2194.95.camel@joe-AO722>
Subject: Re: [PATCH 0/3] BusLogic: Message logging neatening
From: Joe Perches <joe@perches.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 17 May 2013 13:35:23 -0700
In-Reply-To: <1368821880.24376.0.camel@concerto>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
	 <cover.1368765873.git.joe@perches.com> <1368821880.24376.0.camel@concerto>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-17 at 14:18 -0600, Khalid Aziz wrote:
> On Thu, 2013-05-16 at 21:58 -0700, Joe Perches wrote:
> > If you're going through the trouble to fix this CamelCase stuff
> > and make it work on 64 bit, how about a little more cleanup?
> 
> Sounds good to me.

btw, for the BusLogic code:

There seem to be places where addresses are cast to u32.

I don't know the code at all, but that could likely
cause problems with 64 bit addresses.

$ git grep "(u32)" drivers/scsi/BusLogic.c
drivers/scsi/BusLogic.c:                ccb->dma_handle = (u32) blkp + offset;
drivers/scsi/BusLogic.c:                fpinfo->base_addr = (u32) adapter->io_addr;
drivers/scsi/BusLogic.c:        extmbox_req.base_mbox_addr = (u32) adapter->mbox_space_handle;

