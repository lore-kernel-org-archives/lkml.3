Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaACBht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 20:37:49 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44883 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbaACBhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 20:37:48 -0500
Date: Thu, 2 Jan 2014 17:36:39 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v12 06/18] xen/pvh: MMU changes for PVH (v2)
Message-ID: <20140102173639.3869d841@mantra.us.oracle.com>
In-Reply-To: <52C54C82.5010802@citrix.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
	<1388550945-25499-7-git-send-email-konrad.wilk@oracle.com>
	<52C54C82.5010802@citrix.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014 11:24:50 +0000
David Vrabel <david.vrabel@citrix.com> wrote:

> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > .. which are surprinsingly small compared to the amount for PV code.
> > 
> > PVH uses mostly native mmu ops, we leave the generic (native_*) for
> > the majority and just overwrite the baremetal with the ones we need.
> > 
> > We also optimize one - the TLB flush. The native operation would
> > needlessly IPI offline VCPUs causing extra wakeups. Using the
> > Xen one avoids that and lets the hypervisor determine which
> > VCPU needs the TLB flush.
> 
> This TLB flush optimization should be a separate patch.

It's not really an "optimization", we are using PV mechanism instead
of native because PV one performs better. So, I think it's ok to belong
here.

Mukesh

