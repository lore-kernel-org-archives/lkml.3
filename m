Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbaJNQLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:11:35 -0400
Received: from smtp.citrix.com ([66.165.176.89]:65039 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbaJNQLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:11:34 -0400
X-IronPort-AV: E=Sophos;i="5.04,718,1406592000"; 
   d="scan'208";a="181203081"
Message-ID: <543D4AC7.7040409@citrix.com>
Date: Tue, 14 Oct 2014 17:09:43 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Martin Kelly <martin@martingkelly.com>, <xen-devel@lists.xenproject.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>,
        Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH] xen/setup: add paranoid index check and warning
References: <1413249548-26415-1-git-send-email-martin@martingkelly.com> <543CEB56.3080009@citrix.com> <543D2D66.7040000@martingkelly.com>
In-Reply-To: <543D2D66.7040000@martingkelly.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/14 15:04, Martin Kelly wrote:
> On 10/14/2014 02:22 AM, David Vrabel wrote:
>> On 14/10/14 02:19, Martin Kelly wrote:
>>> In a call to set_phys_range_identity, i-1 is used without checking that
>>> i is non-zero. Although unlikely, a bug in the code before it could
>>> cause the value to be 0, leading to erroneous behavior. This patch adds
>>> a check against 0 value and a corresponding warning.
>>
>> This can only happen if the toolstack supplies a memory map with zero
>> entries.  I could see justification for adding a panic at the top of
>> this function in this case, but I can't see the usefulness of this warning.
>>
> 
> Yes, a panic is probably appropriate. What do you think about the
> relative merits of panicing in the callers vs. in the
> sanitize_e820_map function itself (thus to avoid a bunch of similar
> error checks in the callers)?

For Xen, it should panic immediately after getting the memory map.

You will note that there is fallback code for the case when no memory
map is provided.  But I do not think this should be used in the case
where the toolstack provided an empty memory map.

David
