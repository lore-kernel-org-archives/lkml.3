Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423538Ab3FVAXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 20:23:09 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59311 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161521Ab3FVAXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 20:23:07 -0400
MIME-Version: 1.0
In-Reply-To: <51C4C5F3.3050800@sgi.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
	<20130621165142.GA32125@kroah.com>
	<51C48745.9030304@zytor.com>
	<CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com>
	<20130621185056.GA23473@kroah.com>
	<51C4C5F3.3050800@sgi.com>
Date: Fri, 21 Jun 2013 17:23:06 -0700
X-Google-Sender-Auth: TL2Wq0DNRXpICnY99bLNdAE-X3w
Message-ID: <CAE9FiQXaUNbK9+g-7j6gfvLrSvUJFWWKapDv658LPe4VfbH=tQ@mail.gmail.com>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
From: Yinghai Lu <yinghai@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Nathan Zimmer <nzimmer@sgi.com>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 2:30 PM, Mike Travis <travis@sgi.com> wrote:
>
>
> On 6/21/2013 11:50 AM, Greg KH wrote:
>> On Fri, Jun 21, 2013 at 11:44:22AM -0700, Yinghai Lu wrote:
>>> On Fri, Jun 21, 2013 at 10:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>> On 06/21/2013 09:51 AM, Greg KH wrote:
>>>>
>>>> I suspect the cutoff for this should be a lot lower than 8 TB even, more
>>>> like 128 GB or so.  The only concern is to not set the cutoff so low
>>>> that we can end up running out of memory or with suboptimal NUMA
>>>> placement just because of this.
>>>
>>> I would suggest another way:
>>> only boot the system with boot node (include cpu, ram and pci root buses).
>>> then after boot, could add other nodes.
>>
>> What exactly do you mean by "after boot"?  Often, the boot process of
>> userspace needs those additional cpus and ram in order to initialize
>> everything (like the pci devices) properly.
>
> Exactly.  That's why I left both low and high memory on each node.

looks like you assume every node have same ram, and before booting you
you need to know memory layout to append the boot command line.

We have patchset that moving srat table parse early.
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-mm
https://git.kernel.org/cgit/linux/kernel/git/yinghai/linux-yinghai.git/log/?h=for-x86-mm

on top that, we could make your patch pass more simple command like
1/2^n of every node, and only need to pass n instead.

Thanks

Yinghai
