Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab3A2IsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:48:07 -0500
Received: from mga12.intel.com ([143.182.124.36]:49005 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754827Ab3A2IsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:48:04 -0500
MIME-Version: 1.0
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
Date: Tue, 29 Jan 2013 10:48:00 +0200
Message-ID: <CALLzPKZgbz0zCMHVbcDpHX0vv=qt+T0Gi8p+rUa70LJ0E+xrNA@mail.gmail.com>
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric keys
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, dhowells@redhat.com,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 8:52 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Jan 28, 2013 at 05:20:20PM +0200, Kasatkin, Dmitry wrote:
>
> [..]
>> > Ok. I am hoping that it will be more than the kernel command line we
>> > support. In the sense that for digital signatures one needs to parse
>> > the signature, look at what hash algorithm has been used  and then
>> > collect the hash accordingly. It is little different then IMA requirement
>> > of calculating one pre-determine hash for all files.
>>
>> Yes... It is obvious. It's coming.
>> But in general, signer should be aware of requirements and limitation
>> of the platform.
>> It is not really a problem...
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
>
> So what's the idea behind digital signature appraisal? By allowing root to
> unconditionally load the keys in IMA keyring, it seems to circumvent the
> appraisal mechanism.
>

I will answer directly to this email first.
'keyctl setperm' command is used to lock keyring from being able to
add new keys...
Even root is not able to revert locked keyring to original
write-permissive mode.

root@ubuntu:~# cat /proc/keys |grep ima
16a4c685 I--Q---     1 perm 3f010000     0     0 keyring   _ima: 2/4
root@ubuntu:~# keyctl setperm 379897477  0x0b010000
root@ubuntu:~# keyctl add user testkey "testing1" 379897477
add_key: Permission denied
root@ubuntu:~# keyctl setperm 379897477  0x3f010000
keyctl_setperm: Permission denied
root@ubuntu:~# cat /proc/keys |grep ima
16a4c685 I--Q---     1 perm 0b010000     0     0 keyring   _ima: 3/4


- Dmitry

> Thanks
> Vivek
