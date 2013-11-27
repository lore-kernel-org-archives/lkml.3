Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab3K0VWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 16:22:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab3K0VW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 16:22:28 -0500
Date: Wed, 27 Nov 2013 13:22:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, bhelgaas@google.com,
        cl91tp@gmail.com, tianyu.lan@intel.com, khlebnikov@openvz.org,
        gnomes@lxorguk.ukuu.org.uk, indou.takao@jp.fujitsu.com,
        jility09@gmail.com, f.otti@gmx.at, mjg59@srcf.ucam.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Clear Bus Master bit only on kexec reboot
Message-ID: <20131127212227.GA31237@kroah.com>
References: <1385579908-24608-1-git-send-email-khalid.aziz@oracle.com>
 <87ob55my8z.fsf@xmission.com>
 <52964F2C.1020803@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52964F2C.1020803@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 12:59:40PM -0700, Khalid Aziz wrote:
> On 11/27/2013 12:38 PM, ebiederm@xmission.com wrote:
> >Khalid Aziz <khalid.aziz@oracle.com> writes:
> >
> >>Add a flag to tell the PCI subsystem that kernel is shutting down
> >>in prepapration to kexec a kernel. Add code in PCI subsystem to use
> >>this flag to clear Bus Master bit on PCI devices only in case of
> >>kexec reboot. This fixes https://bugzilla.kernel.org/show_bug.cgi?id=63861
> >>and avoids any other issues caused by clearing Bus Master bit on PCI
> >>devices in normal shutdown path. This patch is based on discussion at
> >>http://marc.info/?l=linux-pci&m=138425645204355&w=2
> >
> >Scratches head.
> >
> >Given that most devices already call pci_disable_device which clears the
> >bus master bit how does this change anything meaningful?
> >
> >Is is the problem here that most drivers are lazy and have a noop
> >shutdown method?
> 
> Yes, that is exactly the problem.

Then fix the drivers please.  It's not as if you don't have access to
the source for them all...

greg k-h
