Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaJGTWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:22:20 -0400
Received: from mga03.intel.com ([134.134.136.65]:7782 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846AbaJGTWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:22:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,672,1406617200"; 
   d="scan'208";a="584942102"
Date: Tue, 7 Oct 2014 22:22:10 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Huewe <PeterHuewe@gmx.de>,
        keyrings@linux-nfs.org, jarkko.sakkinnen@linux.intel.com,
        "ksummit-discuss@lists.linuxfoundation.org" 
	<ksummit-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        tpmdd-devel@lists.sourceforge.net,
        James Morris <james.l.morris@oracle.com>,
        linux-ima-devel@lists.sourceforge.net,
        trousers-tech@lists.sourceforge.net
Subject: Re: [TrouSerS-tech] [Ksummit-discuss] TPM MiniSummit @ LinuxCon
 Europe
Message-ID: <20141007192210.GB31645@intel.com>
References: <trinity-2d36367c-59c5-44af-8737-fb503e10af38-1411376491498@3capp-gmx-bs07>
 <CALCETrWdPmSCUkb-neH5ssNmxzsqY0rioQq5qMc2ne7J0JxVLg@mail.gmail.com>
 <543428E1.7050702@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543428E1.7050702@linux.vnet.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 01:54:41PM -0400, Stefan Berger wrote:
> On 09/23/2014 12:42 PM, Andy Lutomirski wrote:
> >On Sep 22, 2014 2:07 AM, "Peter Huewe" <PeterHuewe@gmx.de> wrote:
> >>Hi,
> >>
> >>I would like to 'invite' all interested parties in a short TPM minisummit where we can discuss the following hot topics of the TPM subsystem over a beer or two:
> >>  - State of the TPM Subsystem
> >>  - De-/Initialization Mess
> >>  - Devm'ification
> >>  - Testing
> >>  - TPM 2.0 Support
> >>  - Dependencies / interaction with other subsystems (e.g. keyring / IMA)
> >>  - Status of old 1.1b TPM drivers, deprecation plans
> >>  - ...
> >>
> >I am unlikely to be there, but I have a feature request / food for thought:
> >
> >Using a mandatory userspace daemon (e.g. trousers) for TPM access
> >sucks.  Might it be possible to teach the kernel to handle context
> >save and restore and let multiple processes open the device at once?
> >Then a daemon wouldn't be necessary.
> 
> Why add the complexity of swapping of authenticated sessions and keys into
> the kernel if you can handle this in userspace? You need a library that is
> aware of the number of key slots and slots for sessions in the TPM and swaps
> them in at out when applications need them. Trousers is such a library that
> was designed to cope with the limitations of the device and make its
> functionality available to all applications that want to access it.

One justification might be that kernel is also using TPM? TrouSerS can
not manage session for kernel internal use.

>    Stefan

/Jarkko
