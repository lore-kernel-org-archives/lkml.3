Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934862Ab3DKIIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:08:12 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:40783 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3DKIII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:08:08 -0400
MIME-Version: 1.0
In-Reply-To: <1365627922.2452.32.camel@falcor1.watson.ibm.com>
References: <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
	<20130205181926.GA13942@srcf.ucam.org>
	<20130205183436.GC12853@redhat.com>
	<CALLzPKavbsZgHoJrk5iQ0F1fO21SaeEHmCVCh1G1UKCKB3WZZQ@mail.gmail.com>
	<20130405135000.GB6299@redhat.com>
	<1365450229.3847.56.camel@falcor1.watson.ibm.com>
	<20130408200904.GI28292@redhat.com>
	<CA+5PVA43U_kDSV7p0zhQwmK9pwbVb8qAUePU8svQvoPbDA9iCQ@mail.gmail.com>
	<20130409143852.GH6320@redhat.com>
	<1365563230.3074.107.camel@falcor1.watson.ibm.com>
	<20130410194209.GF6602@redhat.com>
	<1365627922.2452.32.camel@falcor1.watson.ibm.com>
Date: Thu, 11 Apr 2013 11:08:05 +0300
Message-ID: <CACE9dm9P3aFknDNuiwo27F0EWdx8ovg622tjK8biTf7ZVYavLA@mail.gmail.com>
Subject: Re: [RFC 2/2] initramfs with digital signature protection
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Josh Boyer <jwboyer@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(in plain text)

I respond to the original question of this thread.
signed initramfs allows not only to add keys to the keyrings but
perform other initialization,
which requires user-space.
Keys can be embedded into the kernel. This is fine.

Regards

- Dmitry


On Thu, Apr 11, 2013 at 12:05 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Wed, 2013-04-10 at 15:42 -0400, Vivek Goyal wrote:
>> On Tue, Apr 09, 2013 at 11:07:10PM -0400, Mimi Zohar wrote:
>>
>> [..]
>> > The module keyring is a special case.  Loading these keys from the
>> > kernel and, presumably, locking the keyring is probably fine.  In the
>> > case of IMA, however, files will be signed by any number of package
>> > owners.  If the _ima keyring is locked by the kernel, how would you add
>> > these other keys?
>>
>> Who are package owners here. IOW, in typical IMA setup, where are the keys
>> and when are these keys loaded in ima keyring?
>
> Suppose I install third party packages not signed by the distro, but by
> the package owner (eg. google, rpmfusion, ...).  Not only does the
> package signature need to be verified on installation, but the files
> need to be installed with signatures.  For IMA to enforce file
> integrity, the package owner's public key needs to be added to the _ima
> keyring.
>
>> If we trust root and keys can be loaded any time later, then signed
>> initramfs will not solve the problem either.
>
> Locking the keyring in the kernel will limit the set of permitted keys
> to only those specified in UEFI db or builtin.  Locking the keyring in
> the "early" initramfs, will allow the system owner, whose key is in the
> UEFI db, to specify additional keys, such as those for third party
> packages.  Not all public keys belong in the UEFI db.
>
> Mimi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
