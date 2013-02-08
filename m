Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946106Ab3BHIep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:34:45 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:50804 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946088Ab3BHIen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:34:43 -0500
MIME-Version: 1.0
In-Reply-To: <20130207170542.GF6462@redhat.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
	<cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
	<20130207170542.GF6462@redhat.com>
Date: Fri, 8 Feb 2013 10:34:42 +0200
Message-ID: <CALLzPKYCjihDy32=ZQbwVN0jEitVCWKadFCxjN=vw2GnBUFmyA@mail.gmail.com>
Subject: Re: [RFC 2/2] initramfs with digital signature protection
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 7:05 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Feb 05, 2013 at 02:34:50PM +0200, Dmitry Kasatkin wrote:
>
> [..]
>> +static int __init load_initramfs(void)
>> +{
>> +     static char *argv[] = { "pre-init", NULL, };
>> +     extern char *envp_init[];
>> +     int err;
>> +
>> +     /*
>> +      * In case that a resume from disk is carried out by linuxrc or one of
>> +      * its children, we need to tell the freezer not to wait for us.
>> +      */
>> +     current->flags |= PF_FREEZER_SKIP;
>> +
>> +     err = call_usermodehelper_fns("/pre-init", argv, envp_init,
>> +                                   UMH_WAIT_PROC, init_init, init_cleanup,
>> +                                   NULL);
>> +
>> +     current->flags &= ~PF_FREEZER_SKIP;
>> +
>> +     pr_info("initramfs_sig /pre-init completed: %d\n", err);
>> +
>
> Dmitry,
>
> How do we make sure that this is the first call to user mode helpers. I
> see that we first unpacked unsigned initramfs. Then after a while we
> unpacked signed initramfs on /root and did a chroot. But now there is
> a window before chroot, where kernel might call into /sbin/hotplug or
> /sbin/modprobe from unsigned initramfs?
>
> Specifically, I put some printk and I am seeing calls to /sbin/hotplug
> before we even unpacked signed initramfs.

If it really happens, then there something should be done to prevent it.
Can you please send me your patch with printks.
It would be interesting to analyze more what might happen.

Thanks,

Dmitry

>
> Thanks
> Vivek
