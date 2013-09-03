Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114Ab3ICOKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:10:01 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:40616 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760085Ab3ICOJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:09:59 -0400
Date: Tue, 3 Sep 2013 10:09:54 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130903140954.GC10522@htj.dyndns.org>
References: <cover.1378111919.git.agordeev@redhat.com>
 <20130903135541.GB10522@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903135541.GB10522@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 09:55:41AM -0400, Tejun Heo wrote:
> Hmmm.... I've been looking at the code and and a curiosity.  Why does
> multiple MSI support implicitly enabled threaded IRQ handling?  Why
> are those two linked?  Also, do you have any numbers to show that this
> actually is better?  Handling the processing off to a thread isn't a
> light operation.

Also, it probably is a good idea to skip dummy ports when requesting
irqs from ahci_host_activate(), which BTW should probably be renamed
to ahci_host_activate_mmsi().

Thanks.

-- 
tejun
