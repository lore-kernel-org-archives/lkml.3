Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058Ab3IDHVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:21:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797Ab3IDHVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:21:07 -0400
Date: Wed, 4 Sep 2013 09:22:57 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130904072256.GA8726@dhcp-26-207.brq.redhat.com>
References: <cover.1378111919.git.agordeev@redhat.com>
 <3bb1b4375655ecfde5017cc70973d078f2434d5d.1378111919.git.agordeev@redhat.com>
 <20130903141824.GD10522@htj.dyndns.org>
 <20130903161906.GC14221@dhcp-26-207.brq.redhat.com>
 <20130903182731.GA27092@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903182731.GA27092@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 02:27:31PM -0400, Tejun Heo wrote: > Hello,
> 
> On Tue, Sep 03, 2013 at 06:19:06PM +0200, Alexander Gordeev wrote:
> > We must enable maximum possible number of MSIs - the one reported in
> > Multiple Message Capable register. Otherwise ICH device will fallback
> > to MRSM. IOW, if the result of roundup_pow_of_two(n_ports) is not what
> > in Multiple Message Capable register (i.e. as roundup_pow_of_two(6) vs 16)
> > ICH will enforce MRSM mode.
> 
> Hmmm... I think the interface in general is pretty messy.  Wouldn't it
> be much cleaner to have a separate function to query MSICAP and let
> the function just return success / failure?

Actually, sorry for misleading. It is only ICH (I am aware of) that works
this way and I was focused on.

I think a general approach that will cover it all (including ICH and undesired
sharing of interrupt vectors) - start MME from roundup_pow_of_two(n_ports) and
ensure MRSM bit is unset. If not - double MME and retry. If still not and the
limit is reached - fall back to single MSI.

Makes sense?

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
