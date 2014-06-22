Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaFVJTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 05:19:36 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50151 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaFVJTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 05:19:34 -0400
Date: Sun, 22 Jun 2014 12:19:27 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, mgorman@suse.de,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, laijs@cn.fujitsu.com, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Avi Kivity <avi.kivity@gmail.com>
Subject: Re: [RFC PATCH 1/1] Move two pinned pages to non-movable node in kvm.
Message-ID: <20140622091927.GA18167@minantech.com>
References: <1403070600-6083-1-git-send-email-tangchen@cn.fujitsu.com>
 <20140618061230.GA10948@minantech.com>
 <53A136C4.5070206@cn.fujitsu.com>
 <20140619092031.GA429@minantech.com>
 <20140619190024.GA3887@amt.cnet>
 <20140620111509.GE20764@minantech.com>
 <20140620125326.GA22283@amt.cnet>
 <20140620142622.GA28698@minantech.com>
 <20140620203146.GA6580@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620203146.GA6580@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 05:31:46PM -0300, Marcelo Tosatti wrote:
> > > Same with the APIC access page.
> > APIC page is always mapped into guest's APIC base address 0xfee00000.
> > The way it works is that when vCPU accesses page at 0xfee00000 the access
> > is translated to APIC access page physical address. CPU sees that access
> > is for APIC page and generates APIC access exit instead of memory access.
> > If address 0xfee00000 is not mapped by EPT then EPT violation exit will
> > be generated instead, EPT mapping will be instantiated, access retired
> > by a guest and this time will generate APIC access exit.
> 
> Right, confused with the other APIC page which the CPU writes (the vAPIC page) 
> to.
> 
That one is allocated with kmalloc.

--
			Gleb.
