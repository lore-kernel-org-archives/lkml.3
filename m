Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbaHFKxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:53:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:33822 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbaHFKxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:53:10 -0400
X-IronPort-AV: E=Sophos;i="5.01,811,1400025600"; 
   d="scan'208";a="159231878"
Message-ID: <1407322366.15946.8.camel@hamster.uk.xensource.com>
Subject: Re: [PATCH 1/2] xen: Implement ioctl to restrict privcmd to a
 specific domain
From: Frediano Ziglio <frediano.ziglio@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>,
        <linux-api@vger.kernel.org>
Date: Wed, 6 Aug 2014 11:52:46 +0100
In-Reply-To: <53E0DFFE.9090202@citrix.com>
References: <201407311317.s6VDHJV9013633@aserp1020.oracle.com>
	 <20140804202633.GC6380@laptop.dumpdata.com>
	 <1407229819.26842.4.camel@hamster.uk.xensource.com>
	 <20140805134220.GD13057@laptop.dumpdata.com> <53E0DFFE.9090202@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-05 at 14:45 +0100, David Vrabel wrote:
> On 05/08/14 14:42, Konrad Rzeszutek Wilk wrote:
> > 
> >  - Some of these hypercalls don't have an ABI so we can't depend
> >    on them being stable. How do you want to handle that?
> 
> We are not going any further with this series because of this.
> 
> David

Well, this is partially true. We agree the patches as they are cannot be
accepted however in the long term we'd like to find a solution.

The current ABI from user-space to kernel defined by these patches is
perfectly fine (just two ioctl to restrict event channel/privcmd to a
specific domain).

For the implementation we were looking at different approaches:
- add an additional target field in vcpu structure to restrict to a
target for a particular vCPU with some additional hypercalls (like
multicall) that restrict contained hypercalls to a domain;
- an additional hypercall to do domctl but with restriction (this
probably require less changes to current patches);
- using flask. This looks easy to implement but currently code does not
deals well with vCPUs as labels are attached to domains.

Frediano


