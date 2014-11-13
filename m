Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbaKMKhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:37:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:8294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932174AbaKMKhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:37:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,376,1413270000"; 
   d="scan'208";a="607164216"
Message-ID: <1415874993.14686.434.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: BUG() at boot in __phys_addr with DEBUG_VIRTUAL
From: Matt Fleming <matt.fleming@intel.com>
To: Borislav Petkov <bp@suse.de>
CC: Dave Hansen <dave.hansen@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 13 Nov 2014 10:36:33 +0000
In-Reply-To: <20141112172513.GC17793@pd.tnic>
References: <5462999A.7090706@intel.com>
	 <1415784298.14686.323.camel@mfleming-mobl1.ger.corp.intel.com>
	 <54637576.7030004@intel.com> <20141112151106.GB17793@pd.tnic>
	 <54637AD5.6060300@intel.com> <20141112172513.GC17793@pd.tnic>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.180]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 18:25 +0100, Borislav Petkov wrote:
> 
> But before we do that: Matt, why do we need the kernel text mapped 1:1
> in the EFI page table at all?
> 
> You've added this with
> 
> 4f9dbcfc4029 ("x86/efi: Add mixed runtime services support")

So that when we switch into 32-bit mode we can still access the kernel
text via the 1:1 mapping in protected mode.

