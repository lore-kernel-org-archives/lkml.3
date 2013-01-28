Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3A1TwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:52:21 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:46889 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab3A1TwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:52:17 -0500
Message-ID: <1359402694.3906.53.camel@falcor1>
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric
 keys
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, dhowells@redhat.com,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2013 14:51:34 -0500
In-Reply-To: <20130128185242.GB5868@redhat.com>
References: <cover.1358246017.git.dmitry.kasatkin@intel.com>
	 <53febcf9f13e59a1ddd8f8c9826cadbe663f2295.1358246017.git.dmitry.kasatkin@intel.com>
	 <1358895228.2408.14.camel@falcor1>
	 <CALLzPKbNVV+iWzUcsxq0Lk-Hz2BVpCBsEbjHdnRAyjDsF5___g@mail.gmail.com>
	 <20130125210157.GA13152@redhat.com>
	 <CALLzPKY9E8VaFf1GUstTnCeYwLOTm6ozdjJFDwSKWk_JR6QF5w@mail.gmail.com>
	 <20130128151527.GA5868@redhat.com>
	 <CALLzPKbjmoLGMVgY-GygZ9ScV1GNHKaKHGYsHc4=CeoYPL4rmw@mail.gmail.com>
	 <20130128185242.GB5868@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012819-7282-0000-0000-0000138D4CC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 13:52 -0500, Vivek Goyal wrote:
> On Mon, Jan 28, 2013 at 05:20:20PM +0200, Kasatkin, Dmitry wrote:
> 
> [..]
> > > Ok. I am hoping that it will be more than the kernel command line we
> > > support. In the sense that for digital signatures one needs to parse
> > > the signature, look at what hash algorithm has been used  and then
> > > collect the hash accordingly. It is little different then IMA requirement
> > > of calculating one pre-determine hash for all files.
> > 
> > Yes... It is obvious. It's coming.
> > But in general, signer should be aware of requirements and limitation
> > of the platform.
> > It is not really a problem...
> 
> Ok, I have another question. I was looking at your slide deck here.
> 
> http://selinuxproject.org/~jmorris/lss2011_slides/IMA_EVM_Digital_Signature_Support.pdf
> 
> Slide 12 mentions that keys are loaded into the kernel from initramfs. If
> "root" can load any key, what are we protecting against.
> 
> IOW, what good ima_appraise_tcb policy, which tries to appraise any root
> owned file.  A root can sign all the files using its own key and load its
> public key in IMA keyring and then integrity check should pass on all
> root files.

> So what's the idea behind digital signature appraisal? By allowing root to
> unconditionally load the keys in IMA keyring, it seems to circumvent the
> appraisal mechanism.

Vivek, you're asking obvious questions, without understanding that what
you want to do is only now possible because of the work that has gone
into upstreaming the different components of the linux-integrity
subsystem (eg. IMA, trusted/encrypted keys, EVM, (MPI library), and now
IMA-appraisal).  In case you weren't aware, Dmitry made the necessary
changes so that the MPI library could be upstreamed for
EVM/IMA-appraisal digital signature support.

I'm pretty sure that keyrings can be locked, preventing additional keys
from being added.  (If it isn't currently supported, it needs to be.)
The _evm and _ima keyrings should definitely be locked.  When/how this
is done, is yet to be defined.  I'm pretty sure there are a number of
people thinking about this, including David Howells, Dmitry Kataskin,
David Safford and myself.

As I previously said, the next steps are to integrate the
EVM/IMA-appraisal public keys in a safe and trusted manner, without
breaking the secure boot signature chain.

thanks,

Mimi

