Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaJ1FA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:00:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbaJ1FAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 01:00:23 -0400
Message-ID: <544F22E4.9040706@suse.com>
Date: Tue, 28 Oct 2014 06:00:20 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH 0/2] xen: Switch to virtual mapped linear p2m list
References: <1414421551-31555-1-git-send-email-jgross@suse.com> <544E61DD.8050305@citrix.com>
In-Reply-To: <544E61DD.8050305@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 04:16 PM, David Vrabel wrote:
> On 27/10/14 14:52, Juergen Gross wrote:
>> Paravirtualized kernels running on Xen use a three level tree for
>> translation of guest specific physical addresses to machine global
>> addresses. This p2m tree is used for construction of page table
>> entries, so the p2m tree walk is performance critical.
>>
>> By using a linear virtual mapped p2m list accesses to p2m elements
>> can be sped up while even simplifying code. To achieve this goal
>> some p2m related initializations have to be performed later in the
>> boot process, as the final p2m list can be set up only after basic
>> memory management functions are available.
>
> What impact does this have on 32-bit guests which don't have huge amount
> of virtual address space?
>
> I think a 32-bit guest could have up to 64 GiB of PFNs, which would
> require a 128 MiB p2m array, which is too large?

It is 64 MB (one entry on 32 bit is 32 bits :-) ).

With a m2p array of only 16 MB size I doubt a 32 bit guest can be larger
than 16 GB, or am I wrong here?


Juergen
