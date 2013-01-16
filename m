Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3APPyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:54:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112Ab3APPyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:54:10 -0500
Date: Wed, 16 Jan 2013 10:54:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Message-ID: <20130116155406.GC29845@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
 <871udloiku.fsf@xmission.com>
 <1358312159.4593.37.camel@falcor1>
 <87wqvdli1o.fsf@xmission.com>
 <1358344859.4593.66.camel@falcor1>
 <20130116144836.GB29845@redhat.com>
 <1358350391.4593.112.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358350391.4593.112.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 10:33:11AM -0500, Mimi Zohar wrote:

[..]
> > - Also I really could not figure out where does the private signing key
> >   lives. I got the impression that we need to trust installer and
> >   signing somehow happens at installation time. And we wanted signing
> >   to happen at build server and could not trust installer for that.
> 
> Dmitry's ima-evm-utils package signs files.  Depending on the options,
> both the EVM and IMA extended attributes are created.

I was going through following presentation.

http://selinuxproject.org/~jmorris/lss2011_slides/IMA_EVM_Digital_Signature_Support.pdf

On slide 8, it mentons signing.

	evmctl sign --imahash /path/to/file
	evmctl sign --imasig /path/to/file

Can't figure out where does the key for signing come from? Is it already
loaded in any of kernel keyrings.

If yes, I think this is non-starter. One can not distribute the private
key.

Also I am assuming that this is done at installation time? If yes, then
again it does not work as installer does not have private key.

On slide 11, it talks about importing public keys in kernel keyring from
initramfs. As we discussed this will need modification as these keys
need to be signed and signing public key should already be part of 
kernel keyring.

So looking at the signing process, it really does not look like that
I can sign the executable at build server. It looks it needs to be
signed by installer at install time and private key needs to be available
to installer?
 
> 
> >   My understanding of IMA could be wrong. So it would help if you
> >   could list the exact steps about how to achieve the same goal using
> >   IMA.
> 
> http://linux-ima.sourceforge.net/  needs to be updated, but it describes
> the integrity subsystem and includes a link to Dave Safford's original
> whitepaper "An Overview of the Linux Integrity subsystem".

I have gone through the paper in the past and still the quetions remain
unanswered. So it will really help, if you could take a very simple
example of hello-world executable and list the steps needed to be
performed to sign and verify executable.

Thanks
Vivek
