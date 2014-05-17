Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786AbaEQJZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 05:25:36 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:15221 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978AbaEQJZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 05:25:33 -0400
Date: Sat, 17 May 2014 11:24:14 +0200
From: Anthony Iliopoulos <anthony.iliopoulos@huawei.com>
To: Oren Twaig <oren@scalemp.com>
CC: Dave Hansen <dave@sr71.net>, Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Shay Goikhman <shay.goikhman@huawei.com>,
        Paul Mundt <paul.mundt@huawei.com>,
        Carlos Villavieja <villavieja@hps.utexas.edu>,
        Nacho Navarro <nacho.navarro@bsc.es>,
        "Avi Mendelson" <avi.mendelson@tce.technion.ac.il>,
        Yoav Etsion <yetsion@tce.technion.ac.il>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] x86, hugetlb: add missing TLB page invalidation for
 hugetlb_cow()
Message-ID: <20140517092355.GA38103@server-36.huawei.corp>
References: <20140514092948.GA17391@server-36.huawei.corp>
 <5372A067.9010808@sr71.net>
 <20140515170035.GA15779@server-36.huawei.corp>
 <53746721.6060408@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53746721.6060408@scalemp.com>
X-Originating-IP: [10.220.139.36]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oren,

On Thu, May 15, 2014 at 10:05:05AM +0300, Oren Twaig wrote:
> 
> On 05/15/2014 08:00 PM, Anthony Iliopoulos wrote:
> > I have dismissed this case, since I assume that there are many more
> > cycles spent in servicing the TLB invalidation IPI, walking the pgtable
> > plus other related overhead (e.g. sched) than in updating the pte/pmd
> > so I am not sure how possible it would be to hit this condition.
> 
> Hi Anthony,
> 
> I have a question about the above statement. What will happen with multi
> cpu VMs ? won't the race described above can happen ? I.e one virtual CPU
> can will visit the host and the other will continue to encounter your race ?

I don't think there will be any race for the vcpu cases, since the sptes
will be cleared via the mmu_notifier, so this should take care of it
in the same manner as ptep_get_and_clear() does, as described by Dave
earlier in this thread.

Regards,
Anthony
