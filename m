Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbbAIDo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:44:57 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51922 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbbAIDo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:44:56 -0500
Date: Thu, 8 Jan 2015 19:44:40 -0800
From: Darren Hart <dvhart@infradead.org>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Message-ID: <20150109034439.GA9311@vmdeb7>
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
 <1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie>
 <AF233D1473C1364ABD51D28909A1B1B7326E0CC8@PGSMSX105.gar.corp.intel.com>
 <54AE8136.2060400@nexus-software.ie>
 <AF233D1473C1364ABD51D28909A1B1B7326E297E@PGSMSX105.gar.corp.intel.com>
 <54AE9E27.2050307@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AE9E27.2050307@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 03:11:35PM +0000, Bryan O'Donoghue wrote:
> 
> >Suggest to split the imr_del() into 2 functions:-
> >(1) by address + size
> >(2) by IMR index
> >At current implementation, it does not support (2) only because it fails at
> >imr_check_range().
> 
> Hi Boon Leong.
> 
> I'll have a think about that :)
> 
> Just on imr_del() though, it does support removal by way of index.
> 
> +static void __init intel_galileo_imr_init(void)
> +{
> +	unsigned long base  = virt_to_phys(&_text);
> +	unsigned long size = virt_to_phys(&_sinittext) - base - IMR_ALIGN;
> +	int i, ret;
> +
> +	/* Tear down all existing unlocked IMRs */
> +	for (i = 0; i <= QUARK_X1000_IMR_NUM; i++)
> +		imr_del(i, 0, 0);
> 
> That's what the platform code has to do for every unlocked IMR, to make sure
> there are no stale IMRs left that could conflict with the EFI memory map !

I'm OK with a single function so long as by index works without having to
specify the address. Please update the kernel doc to describe this usage though.

-- 
Darren Hart
Intel Open Source Technology Center
