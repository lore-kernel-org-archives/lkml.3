Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaJHU7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:59:21 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47523 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbaJHU7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:59:19 -0400
X-Originating-IP: 50.43.41.112
Date: Wed, 8 Oct 2014 13:59:07 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, keyrings@linux-nfs.org,
        jarkko.sakkinnen@linux.intel.com,
        "ksummit-discuss@lists.linuxfoundation.org" 
	<ksummit-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        tpmdd-devel@lists.sourceforge.net,
        James Morris <james.l.morris@oracle.com>,
        linux-ima-devel@lists.sourceforge.net,
        trousers-tech@lists.sourceforge.net
Subject: Re: [Ksummit-discuss] [tpmdd-devel] [TrouSerS-tech] TPM MiniSummit @
 LinuxCon Europe
Message-ID: <20141008205907.GA7492@thin>
References: <trinity-2d36367c-59c5-44af-8737-fb503e10af38-1411376491498@3capp-gmx-bs07>
 <CALCETrWdPmSCUkb-neH5ssNmxzsqY0rioQq5qMc2ne7J0JxVLg@mail.gmail.com>
 <543428E1.7050702@linux.vnet.ibm.com>
 <20141007180209.GD10432@obsidianresearch.com>
 <5434352A.6080403@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5434352A.6080403@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 02:47:06PM -0400, Stefan Berger wrote:
> On 10/07/2014 02:02 PM, Jason Gunthorpe wrote:
> >On Tue, Oct 07, 2014 at 01:54:41PM -0400, Stefan Berger wrote:
> >
> >>Why add the complexity of swapping of authenticated sessions and keys
> >>into the kernel if you can handle this in userspace? You need a library
> >>that is aware of the number of key slots and slots for sessions in the
> >>TPM and swaps them in at out when applications need them. Trousers is
> >>such a library that was designed to cope with the limitations of the
> >>device and make its functionality available to all applications that
> >>want to access it.
> >How does trousers work with the kernel when the kernel is also using
> >TPM key slots for IMA/keyring/whatever?
> 
> IIRC it only uses a single key slot and swaps all keys in and out of that
> one. If the kernel was to fill up all key (and sessions) slots, TSS would
> probably not work anymore.
> 
> Another argument for the TSS is that you also wouldn't want applications to
> swap out each others keys and sessions and leave them out or assume that
> they would always cleanup if they do not currently need them.

At a minimum, the kernel needs to reserve some number of keys and
sessions for itself (and we should *not* assume that number must be 1).
That means we need some level of kernel arbitration to expose the
remaining items to userspace.  Given that existing level of arbitration,
we don't necessarily *have* to add support for swapping resources in and
out between applications, but we *could* support giving individual TPM
resources to individual userspace processes on an exclusive basis, and
give an error if we run out.

Whether we add dynamic resource management beyond that to userspace or
the kernel is a good question.

- Josh Triplett
