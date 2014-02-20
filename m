Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaBTCg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 21:36:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbaBTCgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 21:36:55 -0500
Date: Wed, 19 Feb 2014 21:36:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jon Mason <jdmason@kudzu.us>
Cc: WANG Chao <chaowang@redhat.com>, Muli Ben-Yehuda <muli@il.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, kexec@lists.infradead.org,
        discuss@x86-64.org, x86@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How could we get rid of saved_max_pfn for calgary iommu?
Message-ID: <20140220023622.GD2970@redhat.com>
References: <20140219061824.GA29703@dhcp-17-89.nay.redhat.com>
 <CAPoiz9yuLg4exX58bh5=XumgAmYNq-9kPjc+f1wa8kMU3-dBbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPoiz9yuLg4exX58bh5=XumgAmYNq-9kPjc+f1wa8kMU3-dBbg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 05:04:22PM -0700, Jon Mason wrote:
> On Tue, Feb 18, 2014 at 11:18 PM, WANG Chao <chaowang@redhat.com> wrote:
> > Hi, All
> >
> > arch/x86/kernel/pci-calgary.c is the only user of saved_max_pfn today:
> >
> > int __init detect_calgary(void)
> > {
> >         [..]
> >         specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
> >                                         saved_max_pfn : max_pfn) * PAGE_SIZE);
> >         [..]
> > }
> 
> IIUC, the purpose of this code is to reuse the TCE table from the
> previous kernel.  Thus, it needs to be of the same size as the
> pre-kdump kernel.  It is using the max_pfn to determine the TCE table
> size in the non-kdump case.  If there is another way to determine the
> size it used before, then I am fine making the change to use that way.

How about passing old tce table size on command line to second kernel.
Given the fact that it is specific to calgary only, we can it very
specific. Say calgary_iommu_old_tce_table_sz=<size>.

But we will then need to know the size of TCE table in first kernel. Is
this information exported to user space somewhere?

Thanks
Vivek
