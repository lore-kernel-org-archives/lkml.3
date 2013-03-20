Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab3CTVL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:11:27 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54875 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab3CTVLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:11:25 -0400
Message-ID: <1363813877.2580.120.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date: Wed, 20 Mar 2013 17:11:17 -0400
In-Reply-To: <1363811856.2553.37.camel@x230.sbx07502.somerma.wayport.net>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
	 <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
	 <1363797717.2580.10.camel@falcor1.watson.ibm.com>
	 <1363798166.2553.29.camel@x230.sbx07502.somerma.wayport.net>
	 <1363802506.2580.55.camel@falcor1.watson.ibm.com>
	 <1363803158.2553.33.camel@x230.sbx07502.somerma.wayport.net>
	 <1363806968.2580.86.camel@falcor1.watson.ibm.com>
	 <1363811856.2553.37.camel@x230.sbx07502.somerma.wayport.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032021-5806-0000-0000-0000206B4E2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 20:37 +0000, Matthew Garrett wrote:
> On Wed, 2013-03-20 at 15:16 -0400, Mimi Zohar wrote:
> > On Wed, 2013-03-20 at 18:12 +0000, Matthew Garrett wrote:
> > > Well, in the absence of hardcoded in-kernel policy, there needs to be
> > > some mechanism for ensuring the integrity of a policy. Shipping a signed
> > > policy initramfs fragment and having any Secure Boot bootloaders pass a
> > > flag in bootparams indicating that the kernel should panic if that
> > > fragment isn't present would seem to be the easiest way of doing that.
> > > Or have I misunderstood the question?
> > 
> > Ok, I was confused by the term "fragmented" initramfs.  So once you have
> > verified the "early" fragmented initramfs signature, this initramfs will
> > load the "trusted" public keys and could also load the MAC policy. (I
> > realize that dracut is currently loading the MAC policy, not the
> > initramfs.)  The MAC policy would then be trusted, right?  Could we then
> > use the LSM labels for defining an integrity policy for kexec?
> 
> Right, that'd be the rough idea. Any further runtime policy updates
> would presumably need to be signed with a trusted key.

I'm really sorry to belabor this point, but can kexec rely on an LSM
label to identify a specific file, out of all the files being executed,
in a secure boot environment?  The SELinux integrity rule for kexec
would then look something like,

appraise func=BPRM_CHECK obj_type=kdump_exec_t appraise_type=imasig

We could then follow this up with Serge's idea of, "a capset
akin to the bounding set, saying you can only have the caps in this set
if the running binary was a signed one."  kexec already requires
CAP_SYS_BOOT.

thanks,

Mimi

