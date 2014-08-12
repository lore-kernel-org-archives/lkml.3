Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaHLSo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:44:27 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:42671 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaHLSoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:44:25 -0400
Date: Tue, 12 Aug 2014 12:44:21 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Benoit Taine <benoit.taine@lip6.fr>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 0/1] Replace DEFINE_PCI_DEVICE_TABLE macro use
Message-ID: <20140812184421.GA5516@google.com>
References: <1407506163-8371-1-git-send-email-benoit.taine@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407506163-8371-1-git-send-email-benoit.taine@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 03:56:02PM +0200, Benoit Taine wrote:
> We should prefer `const struct pci_device_id` over
> `DEFINE_PCI_DEVICE_TABLE` to meet kernel coding style guidelines.
> This issue was reported by checkpatch.
> 
> A simplified version of the semantic patch that makes this change is as
> follows (http://coccinelle.lip6.fr/):
> 
> // <smpl>
> 
> @@
> identifier i;
> declarer name DEFINE_PCI_DEVICE_TABLE;
> initializer z;
> @@
> 
> - DEFINE_PCI_DEVICE_TABLE(i)
> + const struct pci_device_id i[]
> = z;
> 
> // </smpl>
> 
> I previously sent parts of this patch to check wether or not it was
> worth sending, and Bjorn answered:
> > Benoit, how about if you wait until about half-way through the merge
> > window after v3.16 releases, generate an up-to-date single patch, and
> > post that?  Then we can try to get it in before v3.17-rc1 to minimize
> > merge hassles.
> 
> So here it is, based on linux-next on 2014-08-07.

Applied to my for-linus branch for v3.17, thanks!

Bjorn
