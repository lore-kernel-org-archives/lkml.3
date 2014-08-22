Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaHVX3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:29:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31936 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaHVX3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:29:30 -0400
Date: Fri, 22 Aug 2014 16:29:07 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [V0 PATCH 1/2] AMD-PVH: set EFER.NX and EFER.SCE
 for the boot vcpu
Message-ID: <20140822162907.3d769e2b@mantra.us.oracle.com>
In-Reply-To: <20140822120927.03752bc6@mantra.us.oracle.com>
References: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
	<1408587400-18663-2-git-send-email-mukesh.rathor@oracle.com>
	<20140822013904.GA20329@laptop.dumpdata.com>
	<20140821194656.4eea5654@mantra.us.oracle.com>
	<20140822044140.GB11381@nazgul.tnic>
	<20140822120927.03752bc6@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014 12:09:27 -0700
Mukesh Rathor <mukesh.rathor@oracle.com> wrote:

> On Fri, 22 Aug 2014 06:41:40 +0200
> Borislav Petkov <bp@alien8.de> wrote:
> 
> > On Thu, Aug 21, 2014 at 07:46:56PM -0700, Mukesh Rathor wrote:
> > > Intel doesn't have EFER.NX bit.
> > 
> > Of course it does.
> > 
> 
> Right, it does. Some code/comment is misleading... Anyways, reading
> intel SDMs, if I understand the convoluted text correctly, EFER.NX is
> not required to be set for l1.nx to be set, thus allowing for page
> level protection. Where as on AMD, EFER.NX must be set for l1.nx to
> be used. So, in the end, this patch would apply to both amd/intel.... 
> 
> I'll reword and submit.

Err, try again, the section "4.1.1 Three Paging Modes" says:

"Execute-disable access rights are applied only if IA32_EFER.NXE = 1"

So, I guess NX is broken on Intel PVH because EFER.NX is currently 
not being set.  While AMD will #GP if l1.NX is set and EFER.NX is not, 
I guess Intel just ignores the l1.XD if EFER.NX is not set. 

Mukesh
