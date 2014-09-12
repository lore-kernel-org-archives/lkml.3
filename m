Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaILUrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:47:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41791 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaILUrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:47:07 -0400
Date: Fri, 12 Sep 2014 13:46:45 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [V5 PATCH 1/1] x86/xen: Set EFER.NX and EFER.SCE in
 PVH guests
Message-ID: <20140912134645.5c9ce19a@mantra.us.oracle.com>
In-Reply-To: <20140912204258.GA24846@laptop.dumpdata.com>
References: <1410392166-16388-1-git-send-email-mukesh.rathor@oracle.com>
	<1410392166-16388-2-git-send-email-mukesh.rathor@oracle.com>
	<20140912204258.GA24846@laptop.dumpdata.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 16:42:58 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Wed, Sep 10, 2014 at 04:36:06PM -0700, Mukesh Rathor wrote:
> > This fixes two bugs in PVH guests:
> > 
> >   - Not setting EFER.NX means the NX bit in page table entries is
> >     ignored on Intel processors and causes reserved bit page faults
> > on AMD processors.
> > 
> >   - After the Xen commit 7645640d6ff1 ("x86/PVH: don't set EFER_SCE
> > for pvh guest") PVH guests are required to set EFER.SCE to enable
> > the SYSCALL instruction.
> > 
> > Secondary VCPUs are started with pagetables with the NX bit set so
> > EFER.NX must be set before using any stack or data segment.
> > xen_pvh_cpu_early_init() is the new secondary VCPU entry point that
> > sets EFER before jumping to cpu_bringup_and_idle().
> > 
> > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> 
> Huh? So who wrote it? Or did you mean 'Reviewed-by'?

No, meant SOB. I wrote v1, v2, then David came up with V3 and v4, 
then i took comments from v4 and came up with v5.

-Mukesh

