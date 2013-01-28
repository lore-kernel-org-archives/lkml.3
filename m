Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab3A1Swu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:52:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab3A1Sws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:52:48 -0500
Date: Mon, 28 Jan 2013 13:52:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, dhowells@redhat.com,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric
 keys
Message-ID: <20130128185242.GB5868@redhat.com>
References: <cover.1358246017.git.dmitry.kasatkin@intel.com>
 <53febcf9f13e59a1ddd8f8c9826cadbe663f2295.1358246017.git.dmitry.kasatkin@intel.com>
 <1358895228.2408.14.camel@falcor1>
 <CALLzPKbNVV+iWzUcsxq0Lk-Hz2BVpCBsEbjHdnRAyjDsF5___g@mail.gmail.com>
 <20130125210157.GA13152@redhat.com>
 <CALLzPKY9E8VaFf1GUstTnCeYwLOTm6ozdjJFDwSKWk_JR6QF5w@mail.gmail.com>
 <20130128151527.GA5868@redhat.com>
 <CALLzPKbjmoLGMVgY-GygZ9ScV1GNHKaKHGYsHc4=CeoYPL4rmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKbjmoLGMVgY-GygZ9ScV1GNHKaKHGYsHc4=CeoYPL4rmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 05:20:20PM +0200, Kasatkin, Dmitry wrote:

[..]
> > Ok. I am hoping that it will be more than the kernel command line we
> > support. In the sense that for digital signatures one needs to parse
> > the signature, look at what hash algorithm has been used  and then
> > collect the hash accordingly. It is little different then IMA requirement
> > of calculating one pre-determine hash for all files.
> 
> Yes... It is obvious. It's coming.
> But in general, signer should be aware of requirements and limitation
> of the platform.
> It is not really a problem...

Ok, I have another question. I was looking at your slide deck here.

http://selinuxproject.org/~jmorris/lss2011_slides/IMA_EVM_Digital_Signature_Support.pdf

Slide 12 mentions that keys are loaded into the kernel from initramfs. If
"root" can load any key, what are we protecting against.

IOW, what good ima_appraise_tcb policy, which tries to appraise any root
owned file.  A root can sign all the files using its own key and load its
public key in IMA keyring and then integrity check should pass on all
root files.

So what's the idea behind digital signature appraisal? By allowing root to
unconditionally load the keys in IMA keyring, it seems to circumvent the
appraisal mechanism.

Thanks
Vivek
