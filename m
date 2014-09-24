Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaIXEeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 00:34:31 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39806 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaIXEe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 00:34:29 -0400
Date: Tue, 23 Sep 2014 21:34:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, mhocko@suse.cz,
        David Miller <davem@davemloft.net>
Subject: Re: mmotm 2014-09-22-16-57 uploaded
Message-ID: <20140924043423.GA28993@roeck-us.net>
References: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
 <20140923190222.GA4662@roeck-us.net>
 <5421D8B1.1030504@infradead.org>
 <20140923205707.GA14428@roeck-us.net>
 <5421E7E1.80203@infradead.org>
 <20140923215356.GA15481@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923215356.GA15481@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 02:53:56PM -0700, Guenter Roeck wrote:
> 
> > Neither of these patches enables CONFIG_NET.  They just add dependencies.
> > 
> This means CONFIG_NET is now disabled in at least 31 configurations where
> it used to be enabled before (per my count), and there may be additional
> impact due to the additional changes of "select X" to "depends on X".
> 
> 3.18 is going to be interesting.
> 
Actually, turns out the changes are already in 3.17.

In case anyone is interested, here is a list of now broken configurations
(where 'broken' is defined as "CONFIG NET used to be defined, but
is not defined anymore"). No guarantee for completeness or correctness.

mips:gpr_defconfig
mips:ip27_defconfig
mips:jazz_defconfig
mips:loongson3_defconfig
mips:malta_defconfig
mips:malta_kvm_defconfig
mips:malta_kvm_guest_defconfig
mips:mtx1_defconfig
mips:nlm_xlp_defconfig
mips:nlm_xlr_defconfig
mips:rm200_defconfig
parisc:a500_defconfig
parisc:c8000_defconfig
powerpc:c2k_defconfig
powerpc:pmac32_defconfig
powerpc:ppc64_defconfig
powerpc:ppc64e_defconfig
powerpc:pseries_defconfig
powerpc:pseries_le_defconfig
s390:default_defconfig
s390:gcov_defconfig
s390:performance_defconfig
s390:zfcpdump_defconfig
sh:sdk7780_defconfig
sh:sh2007_defconfig
sparc:sparc64_defconfig

Several ia64 configurations were affected as well, but that
has already been fixed.

Guenter
