Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3APOGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:06:08 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35693 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab3APOGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:06:06 -0500
Message-ID: <1358344859.4593.66.camel@falcor1>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Date: Wed, 16 Jan 2013 09:00:59 -0500
In-Reply-To: <87wqvdli1o.fsf@xmission.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	 <871udloiku.fsf@xmission.com> <1358312159.4593.37.camel@falcor1>
	 <87wqvdli1o.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011614-5806-0000-0000-00001E524F75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 23:10 -0800, Eric W. Biederman wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
> 
> > Please remind me why you can't use IMA-appraisal, which was upstreamed
> > in Linux 3.7?  Why another method is needed?
> 
> Good question Vivek?  
> 
> I remeber there was a slight mismatch in the desired attributes.  In
> particular we want signatures that are not generated on the local
> machine.

Right, IMA-appraisal supports different methods of verification.  The
initial methods are hash and digital signature stored in the extended
attribute.  With the queued patches, we can force signature verification
to be of a specific type. It defines a new IMA policy option called
'appraise_type='.

> > With IMA-appraisal, there are a couple of issues that would still need
> > to be addressed:
> > - missing the ability to specify the validation method required.
> > - modify the ima_appraise_tcb policy policy to require elf executables
> > to be digitally signed.
> > - security_bprm_check() is called before the binary handler is known.
> >
> > The first issue is addressed by a set of patches queued to be upstreamed
> > in linux-integrity/next-ima-appraise-status.
> >
> > To address the last issue would either require moving the existing
> > bprm_check or defining a new hook after the binary handler is known.
> 
> Even if there is a small mismatch it certainly sounds like something to
> investigate.  There are a lot of pieces flying around with IMA so an
> appropriate model of what needs to happen isn't in my head.  As opposed
> to a signature in an ELF executable and a key in the kernel.

The original IMA was about measurement and attestation.  IMA-appraisal 
adds local integrity validation and enforcement of the measurement
against a "good" value stored as an extended attribute 'security.ima'.
The initial methods for validating 'security.ima' are hash and digital
signature based.

> Hooks aside in an IMA world where does the signing key live?  Where does
> the signature live?

Initially, the public key used to verify the signature is loaded onto an
IMA specific keyring.  We've discussed embedding public keys inside the
kernel, but haven't done so yet.

The next steps are to ensure the secure boot signature chain of trust
has not been broken.

(I've cc'ed Dmitry Kasatkin on this discussion.  It would also be
appropriate to cc the LSM mailing list.)

thanks,

Mimi

