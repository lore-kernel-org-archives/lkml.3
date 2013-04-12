Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab3DLMDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:03:23 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34019 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab3DLMDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:03:20 -0400
Message-ID: <1365768185.2373.63.camel@falcor1.watson.ibm.com>
Subject: Re: [RFC 2/2] initramfs with digital signature protection
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Josh Boyer <jwboyer@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Apr 2013 08:03:05 -0400
In-Reply-To: <20130411211316.GA26587@redhat.com>
References: <1365450229.3847.56.camel@falcor1.watson.ibm.com>
	 <20130408200904.GI28292@redhat.com>
	 <CA+5PVA43U_kDSV7p0zhQwmK9pwbVb8qAUePU8svQvoPbDA9iCQ@mail.gmail.com>
	 <20130409143852.GH6320@redhat.com>
	 <1365563230.3074.107.camel@falcor1.watson.ibm.com>
	 <20130410194209.GF6602@redhat.com>
	 <1365627922.2452.32.camel@falcor1.watson.ibm.com>
	 <CACE9dm-GZpjco8u6jNxLQpYA8LYSeoVjsyyRXVwxXHzjO-LvGw@mail.gmail.com>
	 <20130411145550.GD21260@redhat.com>
	 <CACE9dm-+CY+aLcsrR8CF2TsL26S1wZbYKYS4ropW3ie6tmMZ+Q@mail.gmail.com>
	 <20130411211316.GA26587@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041212-9360-0000-0000-000011B686AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 17:13 -0400, Vivek Goyal wrote:
> On Thu, Apr 11, 2013 at 09:42:54PM +0300, Dmitry Kasatkin wrote:
> 
> [..]
> > > What other initialization user space need to do where we can't trust
> > > root (even in secureboot mode).
> > >
> > > IOW, if keys can be embedded in kernel (or read from UEFI db and MOK db),
> > > what other operation requires initramfs to be signed. It could very well
> > > be unsigned initramfs like today.
> > >
> > 
> > It looks like you do not hear me.
> > I said that any user space initialization can be done from signed user space.
> > For example IMA policy can be initialized.
> > 
> 
> I am hearing you. Yes I heard you saying  "but perform other initialization,
> which requires user-space". I am just trying to figure out more details.
> You are assuming that a single line statement gives all the context and it
> often might not be the case.
> 
> What makes it important that IMA policy is loaded from an signed initramfs
> and not from unsigned one.

> Also how would you make use of it without secureboot. Only secureboot will
> allow to keep keys in firmware so that one can have a key in there and be
> able to sign initramfs. 

You don't have a monopoly on secure boot.  We're all assuming a secure
boot environment.  The only question is what happens afterwards.  You're
interested in appraising a few particular files: kernel modules, kexec,
and the files kexec loads.  I'm interested in having all files in the
TCB measured and appraised.  Dmitry is interested in having all files
appraised.  The kernel needs to be able to support these and other
scenarios.

> In regular system, distributions do not ship pre-loaded keys so one can 
> not sign initramfs. So only thing possible is that distributions enforce
> some policy in signed initramfs and if distributions have to enforce a
> policy they can do that in kernel itself and no need for signed initramfs.

The difference is that one hard codes policy in the kernel, while the
other doesn't.  Having the policy in a signed initramfs, permits the
platform owner, for example, to change the policy.

Having said this, both Dmitry and I agreed with you that the UEFI keys
can be loaded from the kernel.  We disagree with you, that there is no
other purpose for a signed early initramfs.  Dmitry's example was
loading the IMA policy.  Another example is locking the _ima keyring.
Each scenario has its own requirements.

thanks,

Mimi


