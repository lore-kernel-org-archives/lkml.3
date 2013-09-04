Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762514Ab3IDMar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:30:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757161Ab3IDMap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:30:45 -0400
Date: Wed, 4 Sep 2013 14:32:39 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130904123238.GC8726@dhcp-26-207.brq.redhat.com>
References: <cover.1378111919.git.agordeev@redhat.com>
 <20130903135541.GB10522@htj.dyndns.org>
 <20130903140954.GC10522@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903140954.GC10522@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 10:09:54AM -0400, Tejun Heo wrote:
> On Tue, Sep 03, 2013 at 09:55:41AM -0400, Tejun Heo wrote:
> > Hmmm.... I've been looking at the code and and a curiosity.  Why does
> > multiple MSI support implicitly enabled threaded IRQ handling?  Why
> > are those two linked?  Also, do you have any numbers to show that this
> > actually is better?  Handling the processing off to a thread isn't a
> > light operation.
> 
> Also, it probably is a good idea to skip dummy ports when requesting
> irqs from ahci_host_activate(), which BTW should probably be renamed
> to ahci_host_activate_mmsi().

Hmm.. that is actually a great idea. What I am not sure about whether is
a dummy port still can send (spurious?) interrupts? The hardware interrupt
handler would have to be reworked then. Seems as a yet another topic to me ;)

> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
