Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaAUKBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:01:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbaAUKBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:01:40 -0500
Date: Tue, 21 Jan 2014 11:03:12 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Keith Busch <keith.busch@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] nvme: Cleanup nvme_dev_start() and fix IRQ leak
Message-ID: <20140121100311.GA8847@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <1c441f670f33375b6c41e074baf6e84e6c7bb0c2.1389904166.git.agordeev@redhat.com>
 <CAErSpo4g_xm4vZWZDgyjtJu+z5ARSerQLrtJ6W_peXv4bKwcgg@mail.gmail.com>
 <alpine.LRH.2.03.1401171419370.25844@AMR>
 <20140120083835.GA19068@dhcp-26-207.brq.redhat.com>
 <20140120084212.GC19068@dhcp-26-207.brq.redhat.com>
 <alpine.LRH.2.03.1401201541000.25844@AMR>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.03.1401201541000.25844@AMR>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 03:48:56PM -0700, Keith Busch wrote:
> On Mon, 20 Jan 2014, Alexander Gordeev wrote:
> >This is an attempt to make handling of admin queue in a
> >single scope. This update also fixes a IRQ leak in case
> >nvme_setup_io_queues() failed to allocate enough iomem
> >and bailed out with -ENOMEM errno.
> 
> This definitely seems to improve the code flow, but this leak was already
> fixed in the latest linux-nvme tree with this commit:
> 
> http://git.infradead.org/users/willy/linux-nvme.git/commit/c5dc9192d52a4a3a479f701e97386347d454af84

Oh, that one seems to complicate things even further to me.
Whould you consider the revert?
Sending an improved version against your tree.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
