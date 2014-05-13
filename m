Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbaEMI5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:57:50 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:44223 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaEMI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:57:47 -0400
Date: Tue, 13 May 2014 10:57:41 +0200
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com, ddongch@cn.ibm.com,
        mimu@linux.vnet.ibm.com
Subject: Re: [PATCH v1] vhost: avoid large order allocations
Message-ID: <20140513105741.0cc3c159@bee>
In-Reply-To: <20140513084049.GE29442@redhat.com>
References: <1399970133-46783-1-git-send-email-mimu@linux.vnet.ibm.com>
	<1399970133-46783-2-git-send-email-mimu@linux.vnet.ibm.com>
	<20140513084049.GE29442@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051308-0542-0000-0000-000008F7AF44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 11:40:49 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Please dont' do this, extra indirection hurts performance.
> Instead, please change vhost_net_open and scsi to allocate the whole
> structure with vmalloc if kmalloc fails, along the lines of
> 74d332c13b2148ae934ea94dac1745ae92efe8e5

Thanks for pointing us to: net: extend net_device allocation to vmalloc()

We'll try to adapt.

Michael  

