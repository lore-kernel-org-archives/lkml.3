Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaH1X7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:59:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28854 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaH1X7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:59:19 -0400
Date: Thu, 28 Aug 2014 16:59:12 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V1 PATCH 1/2] PVH: set EFER.NX and EFER.SCE for
 boot vcpu
Message-ID: <20140828165912.581aaa43@mantra.us.oracle.com>
In-Reply-To: <53FF3A32.7000805@citrix.com>
References: <1409178815-2026-1-git-send-email-mukesh.rathor@oracle.com>
	<1409178815-2026-2-git-send-email-mukesh.rathor@oracle.com>
	<53FF3A32.7000805@citrix.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014 15:18:26 +0100
David Vrabel <david.vrabel@citrix.com> wrote:

> On 27/08/14 23:33, Mukesh Rathor wrote:
> > This patch addresses three things for a pvh boot vcpu:
> > 
> >   - NX bug on intel: It was recenlty discovered that NX is not being
> >     honored in PVH on intel since EFER.NX is not being set. The
> > pte.NX bits are ignored if EFER.NX is not set on intel.
> 
> I am unconvinced by this explanation.  The Intel SDM clearly states
> that the XD bit in the page table entries is reserved if EFER.NXE is
> clear, and thus using a entry with XD set and EFER.NXE clear should
> generate a page fault (same as AMD).
> 
> You either need to find out why Intel really worked (perhaps Xen is
> setting EFER.NXE on Intel?) or you need to included an errata (or
> similar) reference.

Nop, verified that again. The vcpu is coming up on efer 0x501,  ie,
LME/LMA/SCE (older xen prior to SCE removal change). The pte entry for
rsp is: 800000003e32b063 that has NX set. No exception is generated upon
push rbp instruction (like on amd).

Could be that Intel docs are incomplete on vmx, I didn't hear back from them 
on the last one I had found. Anyways, we are not addressing an intel errata
here, but fixing our issue of setting the EFER.NX bit.

-Mukesh
