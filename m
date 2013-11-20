Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3KTQOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:14:20 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:52329 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3KTQOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:14:16 -0500
Date: Wed, 20 Nov 2013 11:14:12 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 08/29] PCI/MSI: Make pci_enable_msix() 'nvec'
 argument unsigned int
Message-ID: <20131120161412.GH28946@htj.dyndns.org>
References: <cover.1382103786.git.agordeev@redhat.com>
 <93e145deeb238ad805196762cae696d3ae67f812.1382103786.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93e145deeb238ad805196762cae696d3ae67f812.1382103786.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 18, 2013 at 07:12:08PM +0200, Alexander Gordeev wrote:
> Make pci_enable_msix() and pci_enable_msi_block() consistent
> with regard to the type of 'nvec' argument. Indeed, a number
> of vectors to allocate is a natural value, so make it unsigned.

I'm personally not a big fan of using unsigneds where they're just
used as numbers unless strictly necessary.  They don't really provide
any meaningful protection and we often end up in situations where we
want to encode error conditions in the same type variable as return
value or whatever and end up with silly situations like functions
which take unsigned and returns integer or having a separate err
variable when the high bit of the orignal variable would have worked
just fine.  Also, people have different thresholds for what should be
unsigned and we end up with half things unsigned and the other signed.

I'll defer the decision to Bjorn but I'd vote for converting things to
int.

Thanks.

-- 
tejun
