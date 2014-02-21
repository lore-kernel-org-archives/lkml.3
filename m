Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaBUITx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:19:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbaBUITv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 03:19:51 -0500
Date: Fri, 21 Feb 2014 16:18:06 +0800
From: Baoquan He <bhe@redhat.com>
To: Jon Mason <jdmason@kudzu.us>
Cc: WANG Chao <chaowang@redhat.com>, Muli Ben-Yehuda <muli@il.ibm.com>,
        discuss@x86-64.org, x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: How could we get rid of saved_max_pfn for calgary iommu?
Message-ID: <20140221081806.GB1635@dhcp-16-105.nay.redhat.com>
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

On 02/19/14 at 05:04pm, Jon Mason wrote:
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

>From code the size is from 64K to 8M, saved_max_pfn is needed to get
this. Could it be a fixed size for TCE table? If this can be a fixed
value, E.g 8M,  saved_max_pfn will be not needed any more though a
little memory may be wasted if total ram is smaller than 4G.

Baoquan
Thanks
> 
