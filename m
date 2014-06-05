Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaFEOoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:44:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:42878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbaFEOoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:44:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,981,1392192000"; 
   d="scan'208";a="552113510"
Message-ID: <53908220.4030208@intel.com>
Date: Thu, 05 Jun 2014 07:43:44 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86/efi: Only pass mapped RAM regions to free_bootmem_late()
References: <1401974854-7716-1-git-send-email-matt@console-pimps.org>
In-Reply-To: <1401974854-7716-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 06:27 AM, Matt Fleming wrote:
> free_bootmem_late() expects to only be passed RAM regions that the
> kernel can access, and that have a corresponding 'struct page'. It's
> possible for regions in the EFI memory map to reside in address ranges
> for which pfn_to_page() doesn't work, for instance when running on an
> i386 system with CONFIG_HIGHMEM=n.

FWIW, I think there are also a bunch of ways to hit this if someone uses
mem=, even on 64-bit.
