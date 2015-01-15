Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbbAOJZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:25:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:54869 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbbAOJZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:25:18 -0500
Date: Thu, 15 Jan 2015 10:24:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, David Rientjes <rientjes@google.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Beulich <JBeulich@suse.com>, Richard Weinberger <richard@nod.at>,
        Oren Twaig <oren@scalemp.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Patch v2 07/16] x86/apic: Refine enable_IR_x2apic() and related
 functions
In-Reply-To: <1420615903-28253-8-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1501151023140.5526@nanos>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com> <1420615903-28253-8-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Jiang Liu wrote:

> Refine enable_IR_x2apic() and related functions for better readability.
> 
> It also changes the way to handle IR in XAPIC mode when enabling X2APIC.
> Previously it just skips X2APIC initialization without checking max CPU
> APIC ID in system, which may cause problem if system has CPU with APIC
> ID bigger than 255. So treat IR in XAPIC mode as same as IR is disabled
> when enabling CPU X2APIC.

Please don't do that. This wants to be two patches:

       1) reordering the code

       2) changing the operation

I've split it already, so no need to resend.

Thanks,

	tglx
