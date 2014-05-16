Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbaEPQym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:54:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:26298 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaEPQyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:54:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1068,1389772800"; 
   d="scan'208";a="541686220"
Message-ID: <537642D0.60105@intel.com>
Date: Fri, 16 May 2014 09:54:40 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, David Vrabel <david.vrabel@citrix.com>,
        linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: skip check for spurious faults for non-present faults
References: <1399890550-26475-1-git-send-email-david.vrabel@citrix.com> <53752885.5080306@intel.com> <2edd49ee-077e-4126-b09a-077b7f6be553@email.android.com>
In-Reply-To: <2edd49ee-077e-4126-b09a-077b7f6be553@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 02:20 PM, H. Peter Anvin wrote:
> I'm trying to wrap my head around any forward compatibility
> concerns... if we misidentify a fault as spurious that would be bad.

FWIW, I did go through the bullets in the SDM's "4.10.4.3 Optional
Invalidation".  The only condition not covered by this patch is the one
that talks about "CR4.SMEP = 0...".

But, I don't know of any case where we take a userspace page and make it
supervisor-only, so I don't think this is possible now.
