Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbaIZRgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:36:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042AbaIZRgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:36:09 -0400
Date: Fri, 26 Sep 2014 13:35:46 -0400
From: Dave Jones <davej@redhat.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: hpa@zytor.org, mingo@redhat.com, tglx@linutronix.de, hmh@hmh.eng.br,
        boon.leong.ong@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Quark: Add if/else to setup_arch for Quark TLB bug
Message-ID: <20140926173546.GA9931@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bryan O'Donoghue <pure.logic@nexus-software.ie>, hpa@zytor.org,
	mingo@redhat.com, tglx@linutronix.de, hmh@hmh.eng.br,
	boon.leong.ong@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1411751985-4351-1-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411751985-4351-1-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 06:19:45PM +0100, Bryan O'Donoghue wrote:
 > Quark X1000 incorrectly advertises PGE. In later the stages of boot
 > specifically in early_init_intel we setup_clear_cpu_cap for PGE.
 > At this point in time cpu_has_pge() will still be true.
 > 
 > Use the boot_cpu_data to decide if __flush_tlb_all() or __flush_tlb()
 > should be called subsequent to loading CR3
 
 > +	 * Flush the TLB after loading CR3
 > +	 *
 > +	 * Quark X1000 wrongly advertises PGE. Use boot_cpu_data to
 > +	 * to make sure the TLB is flushed correctly in the early
 > +	 * stage of setup_arch() for Quark X1000.
 > +	 * X86_FEATURE_PGE flag is only setup later stage at
 > +	 * early_cpu_init();
 > +	 */
 > +	if (boot_cpu_data.x86 == 5 && boot_cpu_data.x86_model == 9)
 > +		__flush_tlb();

This also needs a check for the cpu vendor, or this will apply
the workaround on for eg, AMD K6-III's.

	Dave
 
