Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3KVScu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:32:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795Ab3KVSct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:32:49 -0500
Date: Fri, 22 Nov 2013 19:34:40 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 08/29] PCI/MSI: Make pci_enable_msix() 'nvec'
 argument unsigned int
Message-ID: <20131122183439.GE8401@dhcp-26-207.brq.redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
 <93e145deeb238ad805196762cae696d3ae67f812.1382103786.git.agordeev@redhat.com>
 <20131120161412.GH28946@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120161412.GH28946@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:14:12AM -0500, Tejun Heo wrote:
> I'm personally not a big fan of using unsigneds where they're just
> used as numbers unless strictly necessary.  They don't really provide
> any meaningful protection and we often end up in situations where we
> want to encode error conditions in the same type variable as return
> value or whatever and end up with silly situations like functions
> which take unsigned and returns integer or having a separate err
> variable when the high bit of the orignal variable would have worked
> just fine.  Also, people have different thresholds for what should be
> unsigned and we end up with half things unsigned and the other signed.

That sounds convincing. Given that arch hooks do use signed int's 
there is one more reason to convert to signed.

> I'll defer the decision to Bjorn but I'd vote for converting things to
> int.

I will re-post with int's in next version unless Bjorn (someone) speaks
up against.

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
