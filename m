Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934937Ab3IDO4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:56:10 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:63939 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762628Ab3IDO4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:56:08 -0400
Date: Wed, 4 Sep 2013 10:55:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130904145559.GB25788@mtj.dyndns.org>
References: <cover.1378111919.git.agordeev@redhat.com>
 <3bb1b4375655ecfde5017cc70973d078f2434d5d.1378111919.git.agordeev@redhat.com>
 <20130903141824.GD10522@htj.dyndns.org>
 <20130903161906.GC14221@dhcp-26-207.brq.redhat.com>
 <20130903182731.GA27092@mtj.dyndns.org>
 <20130904072256.GA8726@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904072256.GA8726@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 04, 2013 at 09:22:57AM +0200, Alexander Gordeev wrote:
> I think a general approach that will cover it all (including ICH and undesired
> sharing of interrupt vectors) - start MME from roundup_pow_of_two(n_ports) and
> ensure MRSM bit is unset. If not - double MME and retry. If still not and the
> limit is reached - fall back to single MSI.
> 
> Makes sense?

Ugh... I really don't want this sort of retry loop.  I'm still a bit
lost on why this is necessary.  Can you please elaborate?

Thanks.

-- 
tejun
