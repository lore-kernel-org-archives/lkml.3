Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3AQOf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 09:35:27 -0500
Received: from mga05.intel.com ([192.55.52.89]:29968 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756452Ab3AQOfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 09:35:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130116155406.GC29845@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	<1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	<871udloiku.fsf@xmission.com>
	<1358312159.4593.37.camel@falcor1>
	<87wqvdli1o.fsf@xmission.com>
	<1358344859.4593.66.camel@falcor1>
	<20130116144836.GB29845@redhat.com>
	<1358350391.4593.112.camel@falcor1>
	<20130116155406.GC29845@redhat.com>
Date: Thu, 17 Jan 2013 16:35:20 +0200
Message-ID: <CALLzPKZ8c7+WnqBz+XJ3LLiyL3CCmwb8-p6TmcOvQ_Uvcb+ZvQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 5:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jan 16, 2013 at 10:33:11AM -0500, Mimi Zohar wrote:
>
> [..]
>> > - Also I really could not figure out where does the private signing key
>> >   lives. I got the impression that we need to trust installer and
>> >   signing somehow happens at installation time. And we wanted signing
>> >   to happen at build server and could not trust installer for that.
>>
>> Dmitry's ima-evm-utils package signs files.  Depending on the options,
>> both the EVM and IMA extended attributes are created.
>
> I was going through following presentation.
>
> http://selinuxproject.org/~jmorris/lss2011_slides/IMA_EVM_Digital_Signature_Support.pdf
>
> On slide 8, it mentons signing.
>
>         evmctl sign --imahash /path/to/file
>         evmctl sign --imasig /path/to/file
>
> Can't figure out where does the key for signing come from? Is it already
> loaded in any of kernel keyrings.
>
> If yes, I think this is non-starter. One can not distribute the private
> key.
>
> Also I am assuming that this is done at installation time? If yes, then
> again it does not work as installer does not have private key.
>
> On slide 11, it talks about importing public keys in kernel keyring from
> initramfs. As we discussed this will need modification as these keys
> need to be signed and signing public key should already be part of
> kernel keyring.
>
> So looking at the signing process, it really does not look like that
> I can sign the executable at build server. It looks it needs to be
> signed by installer at install time and private key needs to be available
> to installer?
>

This is not like that.
There was never an idea to have a private key on the "target" system.
Because as you said it is wrong...
Signing can be on the build server.
Default keys are /etc/keys/{privkey,pubkey}_evm.pem

Non default keys can be passed as a last parameter in signing in old tools and
as a '--key' parameter in latest tools.

Latest source code includes X509 and asymmetric keys support and is
located here.

http://sourceforge.net/p/linux-ima/ima-evm-utils/


>>
>> >   My understanding of IMA could be wrong. So it would help if you
>> >   could list the exact steps about how to achieve the same goal using
>> >   IMA.
>>
>> http://linux-ima.sourceforge.net/  needs to be updated, but it describes
>> the integrity subsystem and includes a link to Dave Safford's original
>> whitepaper "An Overview of the Linux Integrity subsystem".
>
> I have gone through the paper in the past and still the quetions remain
> unanswered. So it will really help, if you could take a very simple
> example of hello-world executable and list the steps needed to be
> performed to sign and verify executable.

There is no problem in signing on the build server at all.
There is a different problem. Signature is stored in extended attribute.
The problem is how to 'transfer' signature to the target system.
It is necessary to add signatures to the RPM.

There is even a bug report in RedHat bugzilla

https://bugzilla.redhat.com/show_bug.cgi?id=771926

- Dmitry


>
> Thanks
> Vivek
