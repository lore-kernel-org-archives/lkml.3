Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab3K0WBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:01:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3K0WBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:01:07 -0500
Date: Wed, 27 Nov 2013 14:01:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, bhelgaas@google.com,
        cl91tp@gmail.com, tianyu.lan@intel.com, khlebnikov@openvz.org,
        gnomes@lxorguk.ukuu.org.uk, indou.takao@jp.fujitsu.com,
        jility09@gmail.com, f.otti@gmx.at, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Clear Bus Master bit only on kexec reboot
Message-ID: <20131127220106.GA21887@kroah.com>
References: <1385579908-24608-1-git-send-email-khalid.aziz@oracle.com>
 <87ob55my8z.fsf@xmission.com>
 <52964F2C.1020803@oracle.com>
 <20131127212227.GA31237@kroah.com>
 <20131127215309.GA15320@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127215309.GA15320@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 09:53:09PM +0000, Matthew Garrett wrote:
> On Wed, Nov 27, 2013 at 01:22:27PM -0800, Greg KH wrote:
> 
> > Then fix the drivers please.  It's not as if you don't have access to
> > the source for them all...
> 
> Define "fix". It's clearly wrong to disable busmastering at shutdown on 
> some devices, otherwise we wouldn't be having this discussion at all.

I thought it was only "wrong" to disable this on multi-function devices,
which is why some drivers didn't do it.  Otherwise, how would it be any
different to have the global setting?

Anyway, I really don't care either way, but this seems like something
that the drivers should be doing.  What suddenly changed that caused
this problem to occur that hasn't happened in the years prior to now
that drives this to be a stable-kernel issue?

greg k-h
