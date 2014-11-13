Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbaKMKij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:38:39 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:14463 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494AbaKMKih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:38:37 -0500
X-IronPort-AV: E=Sophos;i="5.07,376,1413244800"; 
   d="scan'208";a="192336482"
Message-ID: <54648A27.1060907@citrix.com>
Date: Thu, 13 Nov 2014 10:38:31 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, David Vrabel <david.vrabel@citrix.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <xen-devel@lists.xenproject.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH 3/3] x86/xen: use the maximum MFN to calculate
 the required DMA mask
References: <1415805906-27316-1-git-send-email-david.vrabel@citrix.com>	<1415805906-27316-4-git-send-email-david.vrabel@citrix.com> <546390FC0200007800046E50@mail.emea.novell.com>
In-Reply-To: <546390FC0200007800046E50@mail.emea.novell.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/14 15:55, Jan Beulich wrote:
>>>> On 12.11.14 at 16:25, <david.vrabel@citrix.com> wrote:
>> +u64
>> +xen_swiotlb_get_required_mask(struct device *dev)
>> +{
>> +	u64 max_mfn;
>> +
>> +	max_mfn = HYPERVISOR_memory_op(XENMEM_maximum_ram_page, NULL);
>> +
>> +	return DMA_BIT_MASK(fls64(max_mfn << PAGE_SHIFT) + 1);
>> +}
> The value the hypercall returns is exclusive and an unsigned long.

All hypercalls return long, despite lack of clarity, or in some cases,
documentation to the contrary.

Almost all hypercalls need the ability to return errors in the form of
negative numbers, and those which don't should not be treated any
differently.  Furthermore, the overflow conditions for the compat
version of XENMEM_maximum_ram_page specifically truncate to INT_MAX and
INT_MIN as boundaries, making the return value signed.

~Andrew

