Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbbAMLnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:43:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbbAMLnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:43:24 -0500
Date: Tue, 13 Jan 2015 19:41:08 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, "Li, Zhen-Hua" <zhen-hual@hp.com>,
        dwmw2@infradead.org, indou.takao@jp.fujitsu.com, dyoung@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        jerry.hoemann@hp.com, tom.vaden@hp.com, li.zhang6@hp.com,
        lisa.mitchell@hp.com, billsumnerlinux@gmail.com, rwright@hp.com
Subject: Re: [PATCH v8 02/10] iommu/vt-d: Items required for kdump
Message-ID: <20150113114108.GB24543@dhcp-16-105.nay.redhat.com>
References: <1421046388-27925-1-git-send-email-zhen-hual@hp.com>
 <1421046388-27925-3-git-send-email-zhen-hual@hp.com>
 <20150112152207.GC6343@8bytes.org>
 <20150112152919.GA16162@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112152919.GA16162@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/15 at 10:29am, Vivek Goyal wrote:
> On Mon, Jan 12, 2015 at 04:22:08PM +0100, Joerg Roedel wrote:
> > It looks like you are still copying the io-page-tables from the old
> > kernel into the kdump kernel, is that right? With the approach that was
> > proposed you only need to copy over the context entries 1-1. They are
> > still pointing to the page-tables in the old kernels memory (which is
> > just fine).
> 
> Kdump has the notion of backup region. Where certain parts of old kernels
> memory can be moved to a different location (first 640K on x86 as of now)
> and new kernel can make use of this memory now.

Hi Vivek,

About backup region I am a bit confusing. Just say x86, we usually copy
it to a backup region. And this first 640K will be used as a usable
memory region in 2nd kernel since its content has been copied to backup
region. And that backup region is taken from crashkernel reserved
memory and not passed to 2nd kernel as usable memory region.

Here did you mean the old page table could fall into first 640K memory
region or that reserved backup region?  Since as I understand the backup
region is taken from crashkernel memory which is not used by 1st kernel
process.

Thanks
Baoquan

> 
> So we will have to just make sure that no parts of this old page table
> fall into backup region.
> 
> Thanks
> Vivek
