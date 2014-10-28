Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaJ1R7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:59:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:4356 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbaJ1R7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:59:43 -0400
X-IronPort-AV: E=Sophos;i="5.04,804,1406592000"; 
   d="scan'208";a="185710973"
Message-ID: <544FD8A8.4060709@citrix.com>
Date: Tue, 28 Oct 2014 17:55:52 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 2/2] Xen: switch to linear virtual mapped sparse p2m list
References: <1414421551-31555-1-git-send-email-jgross@suse.com> <1414421551-31555-3-git-send-email-jgross@suse.com>
In-Reply-To: <1414421551-31555-3-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/10/14 14:52, Juergen Gross wrote:
> At start of the day the Xen hypervisor presents a contiguous mfn list
> to a pv-domain. In order to support sparse memory this mfn list is
> accessed via a three level p2m tree built early in the boot process.
> Whenever the system needs the mfn associated with a pfn this tree is
> used to find the mfn.
> 
> Instead of using a software walked tree for accessing a specific mfn
> list entry this patch is creating a virtual address area for the
> entire possible mfn list including memory holes. The holes are
> covered by mapping a pre-defined  page consisting only of "invalid
> mfn" entries. Access to a mfn entry is possible by just using the
> virtual base address of the mfn list and the pfn as index into that
> list. This speeds up the (hot) path of determining the mfn of a
> pfn.

I'm generally in favour of this I think but this is just too big to
review carefully. Is there any way you can split this up?  Perhaps with
some preparatory patches before the big switch to the linear array?

David
