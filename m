Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3LTXUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:20:20 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:60741 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LTXUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:20:18 -0500
MIME-Version: 1.0
In-Reply-To: <87a9fvqfs4.fsf@xmission.com>
References: <20131121190350.GC17070@kroah.com>
	<20131121190620.GA25951@srcf.ucam.org>
	<20131121191305.GK16208@redhat.com>
	<20131121191907.GA26366@srcf.ucam.org>
	<20131122185706.GK4046@redhat.com>
	<87vbzju6ql.fsf@xmission.com>
	<20131125163920.GC23094@redhat.com>
	<87fvqj2vxz.fsf@xmission.com>
	<20131126142759.GA5473@redhat.com>
	<20131219125439.GA6379@lst.de>
	<20131220141917.GB27063@redhat.com>
	<87a9fvqfs4.fsf@xmission.com>
Date: Fri, 20 Dec 2013 15:20:16 -0800
X-Google-Sender-Auth: M0plK3xcir9joIBn0abYDTqklA4
Message-ID: <CAGXu5jKJ88J-++nvkPVvghkXbN+_mB=T1siSDF7yoXQ-d-ONxg@mail.gmail.com>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
From: Kees Cook <keescook@chromium.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Torsten Duwe <duwe@lst.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 3:11 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
>
>> On Thu, Dec 19, 2013 at 01:54:39PM +0100, Torsten Duwe wrote:
>>> On Tue, Nov 26, 2013 at 09:27:59AM -0500, Vivek Goyal wrote:
>
>>> IMO it's up to user land to search lists of certificates, and present
>>> only the final chain of trust to the kernel for checking.
>>>
>>> ELF is the preferred format for most sane OSes and firmware, and a detached
>>> signature would probably be simplest to check. If we have the choice,
>>> without restrictions from braindead boot loaders, ELF should be first.
>>> And if the pesigning isn't usable and another sig is needed anyway,
>>> why not apply that to vmlinux(.gz) ?
>>
>> I have yet to look deeper into it that if we can sign elf images and
>> just use elf loader. And can use space extract the elf image out of
>> a bzImage and pass it to kernel.
>>
>> Even if it is doable, one disadvantage seemed to be that extracted
>> elf images will have to be written to a file so thta it's file descriptor
>> can be passed to kernel. And that assumed writable root and we chrome
>> folks seems to have setups where root is not writable.
>
> In that case the chrome folks would simply have to use an ELF format
> kernel and not a bzImage.

If we're doing fd origin verification (not signatures), can't we
continue to use a regular bzImage?

-Kees

-- 
Kees Cook
Chrome OS Security
