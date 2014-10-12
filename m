Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaJLXpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 19:45:44 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50736 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaJLXpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 19:45:40 -0400
Message-ID: <1413157533.14699.32.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [tpmdd-devel] [TrouSerS-tech] [Ksummit-discuss] TPM MiniSummit
 @ LinuxCon Europe
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, keyrings@linux-nfs.org,
        jarkko.sakkinnen@linux.intel.com,
        "ksummit-discuss@lists.linuxfoundation.org" 
	<ksummit-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        LSM List <linux-security-module@vger.kernel.org>,
        tpmdd-devel@lists.sourceforge.net,
        James Morris <james.l.morris@oracle.com>,
        linux-ima-devel@lists.sourceforge.net,
        trousers-tech@lists.sourceforge.net, Peter Huewe <PeterHuewe@gmx.de>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Date: Sun, 12 Oct 2014 19:45:33 -0400
In-Reply-To: <20141007192210.GB31645@intel.com>
References: <trinity-2d36367c-59c5-44af-8737-fb503e10af38-1411376491498@3capp-gmx-bs07>
	 <CALCETrWdPmSCUkb-neH5ssNmxzsqY0rioQq5qMc2ne7J0JxVLg@mail.gmail.com>
	 <543428E1.7050702@linux.vnet.ibm.com> <20141007192210.GB31645@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101223-8236-0000-0000-0000061992E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 22:22 +0300, Jarkko Sakkinen wrote: 
> On Tue, Oct 07, 2014 at 01:54:41PM -0400, Stefan Berger wrote:
> > On 09/23/2014 12:42 PM, Andy Lutomirski wrote:
> > >On Sep 22, 2014 2:07 AM, "Peter Huewe" <PeterHuewe@gmx.de> wrote:
> > >>Hi,
> > >>
> > >>I would like to 'invite' all interested parties in a short TPM minisummit where we can discuss the following hot topics of the TPM subsystem over a beer or two:
> > >>  - State of the TPM Subsystem
> > >>  - De-/Initialization Mess
> > >>  - Devm'ification
> > >>  - Testing
> > >>  - TPM 2.0 Support
> > >>  - Dependencies / interaction with other subsystems (e.g. keyring / IMA)
> > >>  - Status of old 1.1b TPM drivers, deprecation plans
> > >>  - ...
> > >>
> > >I am unlikely to be there, but I have a feature request / food for thought:
> > >
> > >Using a mandatory userspace daemon (e.g. trousers) for TPM access
> > >sucks.  Might it be possible to teach the kernel to handle context
> > >save and restore and let multiple processes open the device at once?
> > >Then a daemon wouldn't be necessary.
> > 
> > Why add the complexity of swapping of authenticated sessions and keys into
> > the kernel if you can handle this in userspace? You need a library that is
> > aware of the number of key slots and slots for sessions in the TPM and swaps
> > them in at out when applications need them. Trousers is such a library that
> > was designed to cope with the limitations of the device and make its
> > functionality available to all applications that want to access it.
> 
> One justification might be that kernel is also using TPM? TrouSerS can
> not manage session for kernel internal use.

I had a discussion way back when with Rajiv Andrade, when he was the
maintainer.  Instead of assuming Trousers didn't use up all the slots,
one slot would be reserved for the kernel's use.  Need to check and see
if this was ever implemented.

Mimi


