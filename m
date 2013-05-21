Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3EUQ2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:28:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab3EUQ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:28:22 -0400
Date: Tue, 21 May 2013 19:28:11 +0300
From: Gleb Natapov <gleb@redhat.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v3 5/5] mips/kvm: Fix ABI by moving manipulation of CP0
 registers to KVM_{G,S}ET_MSRS
Message-ID: <20130521162811.GE14287@redhat.com>
References: <1369083686-27524-1-git-send-email-ddaney.cavm@gmail.com>
 <1369083686-27524-6-git-send-email-ddaney.cavm@gmail.com>
 <20130521153752.GD14287@redhat.com>
 <519B9EF2.8020107@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519B9EF2.8020107@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 09:21:06AM -0700, David Daney wrote:
> On 05/21/2013 08:37 AM, Gleb Natapov wrote:
> >On Mon, May 20, 2013 at 02:01:26PM -0700, David Daney wrote:
> >>From: David Daney <david.daney@cavium.com>
> >>
> >>Because not all 256 CP0 registers are ever implemented, we need a
> >>different method of manipulating them.  Use the
> >>KVM_GET_MSRS/KVM_SET_MSRS mechanism as x86 does for its MSRs.
> >>
> >Have you looked at KVM_(GET|SET)_ONE_REG interface (not used by x86, but is
> >used bu arm/ppc/s390). It looks like it is more suitable for your case.
> >Actually you can use it instead of KVM_(GET|SET)_REGS for all registers.
> 
> Yes, I suppose it could be used.  One problem it has is that there
> is no way to query the set of supported registers. 
KVM_GET_REG_LIST

>                                                     Also you have to
> make multiple calls to set multiple registers, which involves
> vcpu_{load,put} for each register.
> 
How often this happens on the fast path on mips? On x86 this never
happens on the fast path so it uses KVM_(GET|SET)_REGS mostly for
historical reasons.

> We will definitely implement it for all the FP and General Purpose
> registers.
> 
> >
> >>Code related to implementing KVM_GET_MSRS/KVM_SET_MSRS is consolidated
> 

--
			Gleb.
