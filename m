Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3KVB3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:29:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60196 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab3KVB31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:29:27 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <8761rl73s7.fsf@xmission.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com> <8761rl73s7.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 21 Nov 2013 17:28:38 -0800
To: ebiederm@xmission.com, Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        mjg59@srcf.ucam.org, greg@kroah.com
Message-ID: <5cb078ff-e0d3-478b-ba1c-c16d71c32e02@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What do you need from ELF?

ebiederm@xmission.com wrote:
>Vivek Goyal <vgoyal@redhat.com> writes:
>
>> Current proposed secureboot implementation disables kexec/kdump
>because
>> it can allow unsigned kernel to run on a secureboot platform. Intial
>> idea was to sign /sbin/kexec binary and let that binary do the kernel
>> signature verification. I had posted RFC patches for this apparoach
>> here.
>>
>> https://lkml.org/lkml/2013/9/10/560
>>
>> Later we had discussion at Plumbers and most of the people thought
>> that signing and trusting /sbin/kexec is becoming complex. So a 
>> better idea might be let kernel do the signature verification of
>> new kernel being loaded. This calls for implementing a new system
>call
>> and moving lot of user space code in kernel.
>>
>> kexec_load() system call allows loading a kexec/kdump kernel and jump
>> to that kernel at right time. Though a lot of processing is done in
>> user space which prepares a list of segments/buffers to be loaded and
>> kexec_load() works on that list of segments. It does not know what's
>> contained in those segments.
>>
>> Now a new system call kexec_file_load() is implemented which takes
>> kernel fd and initrd fd as parameters. Now kernel should be able
>> to verify signature of newly loaded kernel. 
>>
>> This is an early RFC patchset. I have not done signature handling
>> part yet. This is more of a minimal patch to show how new system
>> call and functionality will look like. Right now it can only handle
>> bzImage with 64bit entry point on x86_64. No EFI, no x86_32  or any
>> other architecture. Rest of the things can be added slowly as need
>> arises. In first iteration, I have tried to address most common use
>case
>> for us.
>>
>> Any feedback is welcome.
>
>Before you are done we need an ELF loader.  bzImage really is very
>uninteresting.  To the point I am not at all convinced that an in
>kernel
>loader should support it.
>
>There is also a huge missing piece of this in that your purgatory is
>not
>checking a hash of the loaded image before jumping too it.  Without
>that
>this is a huge regression at least for the kexec on panic case.  We
>absolutely need to check that the kernel sitting around in memory has
>not been corrupted before we let it run very far.
>
>Eric

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
