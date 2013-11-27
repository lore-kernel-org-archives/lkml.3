Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab3K0WIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:08:01 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41038 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab3K0WHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:07:48 -0500
Date: Wed, 27 Nov 2013 22:07:04 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, bhelgaas@google.com,
        cl91tp@gmail.com, tianyu.lan@intel.com, khlebnikov@openvz.org,
        gnomes@lxorguk.ukuu.org.uk, indou.takao@jp.fujitsu.com,
        jility09@gmail.com, f.otti@gmx.at, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Clear Bus Master bit only on kexec reboot
Message-ID: <20131127220704.GA15609@srcf.ucam.org>
References: <1385579908-24608-1-git-send-email-khalid.aziz@oracle.com>
 <87ob55my8z.fsf@xmission.com>
 <52964F2C.1020803@oracle.com>
 <20131127212227.GA31237@kroah.com>
 <20131127215309.GA15320@srcf.ucam.org>
 <20131127220106.GA21887@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127220106.GA21887@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 02:01:06PM -0800, Greg KH wrote:
> On Wed, Nov 27, 2013 at 09:53:09PM +0000, Matthew Garrett wrote:
> > On Wed, Nov 27, 2013 at 01:22:27PM -0800, Greg KH wrote:
> > 
> > > Then fix the drivers please.  It's not as if you don't have access to
> > > the source for them all...
> > 
> > Define "fix". It's clearly wrong to disable busmastering at shutdown on 
> > some devices, otherwise we wouldn't be having this discussion at all.
> 
> I thought it was only "wrong" to disable this on multi-function devices,
> which is why some drivers didn't do it.  Otherwise, how would it be any
> different to have the global setting?

kexec doesn't jump into the firmware, so firmware assumptions about the 
state of the busmaster bit don't matter.

> Anyway, I really don't care either way, but this seems like something
> that the drivers should be doing.  What suddenly changed that caused
> this problem to occur that hasn't happened in the years prior to now
> that drives this to be a stable-kernel issue?

We started clearing the busmaster bit on all devices on shutdown in 
3.something in order to ensure that DMA wasn't occuring while we were 
in the process of performing a kexec. Some machines freeze on shutdown 
as a result. This patch reverts back to the original behaviour on real 
shutdown, while still avoiding the "This PCI device scribbled over my 
new kernel" kexec case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
