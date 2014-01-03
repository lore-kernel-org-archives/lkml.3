Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaACKOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 05:14:16 -0500
Received: from smtp.citrix.com ([66.165.176.89]:12262 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbaACKOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 05:14:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,597,1384300800"; 
   d="scan'208";a="89487629"
Message-ID: <52C68D73.70005@citrix.com>
Date: Fri, 3 Jan 2014 10:14:11 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v12 06/18] xen/pvh: MMU changes for PVH (v2)
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>	<1388550945-25499-7-git-send-email-konrad.wilk@oracle.com>	<52C54C82.5010802@citrix.com> <20140102173639.3869d841@mantra.us.oracle.com>
In-Reply-To: <20140102173639.3869d841@mantra.us.oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/14 01:36, Mukesh Rathor wrote:
> On Thu, 2 Jan 2014 11:24:50 +0000
> David Vrabel <david.vrabel@citrix.com> wrote:
> 
>> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
>>> From: Mukesh Rathor <mukesh.rathor@oracle.com>
>>>
>>> .. which are surprinsingly small compared to the amount for PV code.
>>>
>>> PVH uses mostly native mmu ops, we leave the generic (native_*) for
>>> the majority and just overwrite the baremetal with the ones we need.
>>>
>>> We also optimize one - the TLB flush. The native operation would
>>> needlessly IPI offline VCPUs causing extra wakeups. Using the
>>> Xen one avoids that and lets the hypervisor determine which
>>> VCPU needs the TLB flush.
>>
>> This TLB flush optimization should be a separate patch.
> 
> It's not really an "optimization", we are using PV mechanism instead
> of native because PV one performs better.

Um.  Isn't that the very definition of an optimization?

I do think it is better for the essential MMU changes to be clearly
separate from the optional ones.

David

