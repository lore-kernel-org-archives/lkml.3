Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab3ICS1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:27:42 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:40995 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab3ICS1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:27:38 -0400
Date: Tue, 3 Sep 2013 14:27:31 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130903182731.GA27092@mtj.dyndns.org>
References: <cover.1378111919.git.agordeev@redhat.com>
 <3bb1b4375655ecfde5017cc70973d078f2434d5d.1378111919.git.agordeev@redhat.com>
 <20130903141824.GD10522@htj.dyndns.org>
 <20130903161906.GC14221@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903161906.GC14221@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 03, 2013 at 06:19:06PM +0200, Alexander Gordeev wrote:
> We must enable maximum possible number of MSIs - the one reported in
> Multiple Message Capable register. Otherwise ICH device will fallback
> to MRSM. IOW, if the result of roundup_pow_of_two(n_ports) is not what
> in Multiple Message Capable register (i.e. as roundup_pow_of_two(6) vs 16)
> ICH will enforce MRSM mode.

Hmmm... I think the interface in general is pretty messy.  Wouldn't it
be much cleaner to have a separate function to query MSICAP and let
the function just return success / failure?

Thanks.

-- 
tejun
