Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3LCPRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:17:10 -0500
Received: from smtp.citrix.com ([66.165.176.89]:21786 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab3LCPRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:17:03 -0500
X-IronPort-AV: E=Sophos;i="4.93,818,1378857600"; 
   d="scan'208";a="80127075"
Message-ID: <1386083821.13256.42.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>
Date: Tue, 3 Dec 2013 15:17:01 +0000
In-Reply-To: <529DF4A0.50103@citrix.com>
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
			 <529DBA07.6090108@citrix.com>
		 <1386068884.13256.9.camel@kazak.uk.xensource.com>
		 <529DC7BA.7080506@citrix.com>
	 <1386078108.13256.30.camel@kazak.uk.xensource.com>
	 <529DF4A0.50103@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 15:11 +0000, David Vrabel wrote:
> On 03/12/13 13:41, Ian Campbell wrote:
> > On Tue, 2013-12-03 at 11:59 +0000, David Vrabel wrote:
> >> On 03/12/13 11:08, Ian Campbell wrote:
> >>> On Tue, 2013-12-03 at 11:01 +0000, David Vrabel wrote:
> >>>> On 03/12/13 10:57, Roger Pau Monne wrote:
> >>>>> Using __packed__ on the public interface is not correct, this
> >>>>> structures should be compiled using the native ABI, and __packed__
> >>>>> should only be used in the backend counterpart of those structures
> >>>>> (which needs to handle different ABIs).
> >>>>>
> >>>>> This was even worse in the ARM case, where the Linux kernel was
> >>>>> incorrectly using the X86_32 protocol ABI. This patch fixes it, but
> >>>>> also breaks compatibility, so an ARM DomU kernel compiled with
> >>>>> this patch will fail to communicate with PV disk devices unless the
> >>>>> Dom0 also has this patch.
> >>>>
> >>>> This ABI change needs to be justified.  Why do you think it is
> >>>> acceptable to break existing Linux guests?  Because I don't think it is.
> >>>
> >>> As I explained in my reply those guests are buggy.
> >>
> >> The kernel has a strong policy on not changing ABIs, even to fix bugs.
> >> I don't think a bug fix alone is sufficient justification for ABI breakage.
> > 
> > This is not the kernels ABI to fix in stone. The ABI is defined by the
> > upstream Xen project and Linux has failed to follow the specified ABI
> > correctly.
> 
> I disagree. The working back and front end implementations have created
> a new, different ABI.

Which is completely incompatible with every other OS. This issue was
discovered trying to run a NetBSD guest on a Linux dom0.

I will not legitimize this broken ABI because then all these other OSes
would need to implement all of this compatibility cruft in order to
interoperate with Linux.

> > There is no deployed legacy of guests to support here.
> 
> I not sure I agree. It does seem to be widely used and I'm not sure we
> have sufficient visibility on how Xen on Arm is being used to know if
> this change will cause other people problems.

It's being widely developed on and used for PoC etc. It is not widely
deployed.

> If Konrad and Boris agree that breaking the kernel's ABI in this way is
> acceptable in this specific case, I'll defer to them.

My opinion as Xen on ARM hypervisor maintainer is that this is the right
thing to do in this case.

Ian.

