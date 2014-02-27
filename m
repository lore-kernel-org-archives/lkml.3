Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaB0DeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:34:17 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57261 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752466AbaB0DeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:34:15 -0500
X-Sasl-enc: YCHKrtBsnLT6PDSO5Z+TP38bh1wqyNx9Mocrem4wUGl8 1393472050
Date: Wed, 26 Feb 2014 19:37:16 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: linux-next: build failure after merge of the char-misc tree
Message-ID: <20140227033716.GC31199@kroah.com>
References: <20140221164711.9e62ae1f03fe1166943a2a14@canb.auug.org.au>
 <20140226174721.3f27c7ca917e9c73b0fb8ce5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226174721.3f27c7ca917e9c73b0fb8ce5@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 05:47:21PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Fri, 21 Feb 2014 16:47:11 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the char-misc tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > In file included from drivers/misc/mei/hw-txe.c:25:0:
> > drivers/misc/mei/hw-txe.h:63:1: error: unknown type name 'irqreturn_t'
> >  irqreturn_t mei_txe_irq_quick_handler(int irq, void *dev_id);
> >  ^
> > 
> > Caused by commit 266f6178d1f1 ("mei: txe: add hw-txe.h header file") but
> > probably exposed by commit 46cb7b1bd86f ("PCI: Remove unused SR-IOV VF
> > Migration support") from the pci tree which removed the include of
> > irqreturn.h from pci.h ...
> > 
> > See Rule 1 from Documentation/SubmitChecklist ...
> > 
> > I added the following merge fix patch (this should be applied to the
> > char-misc tree):
> 
> Ping?

I've merged everything together, and it all builds properly for me in
the char-misc branches, so I don't see what is missing.  What did I do
wrong?

confused,

greg k-h
