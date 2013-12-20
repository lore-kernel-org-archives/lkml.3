Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3LTXLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:11:43 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57873 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3LTXLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:11:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Torsten Duwe <duwe@lst.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, hpa@zytor.com,
        Peter Jones <pjones@redhat.com>, Kees Cook <keescook@chromium.org>
References: <20131121190350.GC17070@kroah.com>
	<20131121190620.GA25951@srcf.ucam.org>
	<20131121191305.GK16208@redhat.com>
	<20131121191907.GA26366@srcf.ucam.org>
	<20131122185706.GK4046@redhat.com> <87vbzju6ql.fsf@xmission.com>
	<20131125163920.GC23094@redhat.com> <87fvqj2vxz.fsf@xmission.com>
	<20131126142759.GA5473@redhat.com> <20131219125439.GA6379@lst.de>
	<20131220141917.GB27063@redhat.com>
Date: Fri, 20 Dec 2013 15:11:23 -0800
In-Reply-To: <20131220141917.GB27063@redhat.com> (Vivek Goyal's message of
	"Fri, 20 Dec 2013 09:19:17 -0500")
Message-ID: <87a9fvqfs4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18Rvn9wAYE8q3BoBON0V4IJflkRJb/WG+c=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4108]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in kernel kexec
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Dec 19, 2013 at 01:54:39PM +0100, Torsten Duwe wrote:
>> On Tue, Nov 26, 2013 at 09:27:59AM -0500, Vivek Goyal wrote:

>> IMO it's up to user land to search lists of certificates, and present
>> only the final chain of trust to the kernel for checking.
>> 
>> ELF is the preferred format for most sane OSes and firmware, and a detached
>> signature would probably be simplest to check. If we have the choice,
>> without restrictions from braindead boot loaders, ELF should be first.
>> And if the pesigning isn't usable and another sig is needed anyway,
>> why not apply that to vmlinux(.gz) ?
>
> I have yet to look deeper into it that if we can sign elf images and
> just use elf loader. And can use space extract the elf image out of 
> a bzImage and pass it to kernel.
>
> Even if it is doable, one disadvantage seemed to be that extracted 
> elf images will have to be written to a file so thta it's file descriptor
> can be passed to kernel. And that assumed writable root and we chrome
> folks seems to have setups where root is not writable.

In that case the chrome folks would simply have to use an ELF format
kernel and not a bzImage.

Eric
