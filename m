Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbaKMKx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:53:26 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:38673 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbaKMKxY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Thu, 13 Nov 2014 05:53:24 -0500
Message-Id: <54649BB2020000780004725A@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Thu, 13 Nov 2014 10:53:22 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Cooper" <andrew.cooper3@citrix.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>, <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Ingo Molnar" <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        "H. PeterAnvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 3/3] x86/xen: use the maximum MFN to
 calculate the required DMA mask
References: <1415805906-27316-1-git-send-email-david.vrabel@citrix.com>
 <1415805906-27316-4-git-send-email-david.vrabel@citrix.com>
 <546390FC0200007800046E50@mail.emea.novell.com>
 <54648A27.1060907@citrix.com>
In-Reply-To: <54648A27.1060907@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.11.14 at 11:38, <andrew.cooper3@citrix.com> wrote:
> On 12/11/14 15:55, Jan Beulich wrote:
>>>>> On 12.11.14 at 16:25, <david.vrabel@citrix.com> wrote:
>>> +u64
>>> +xen_swiotlb_get_required_mask(struct device *dev)
>>> +{
>>> +	u64 max_mfn;
>>> +
>>> +	max_mfn = HYPERVISOR_memory_op(XENMEM_maximum_ram_page, NULL);
>>> +
>>> +	return DMA_BIT_MASK(fls64(max_mfn << PAGE_SHIFT) + 1);
>>> +}
>> The value the hypercall returns is exclusive and an unsigned long.
> 
> All hypercalls return long, despite lack of clarity, or in some cases,
> documentation to the contrary.

The emphasis wasn't on "unsigned" but on "long". But see also my
later reply to that same mail.

Jan

