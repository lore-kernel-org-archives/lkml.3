Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3LUBc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 20:32:59 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48976 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab3LUBc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 20:32:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Torsten Duwe <duwe@lst.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Peter Jones <pjones@redhat.com>, Kees Cook <keescook@chromium.org>
References: <20131121190350.GC17070@kroah.com>
	<20131121190620.GA25951@srcf.ucam.org>
	<20131121191305.GK16208@redhat.com>
	<20131121191907.GA26366@srcf.ucam.org>
	<20131122185706.GK4046@redhat.com> <87vbzju6ql.fsf@xmission.com>
	<20131125163920.GC23094@redhat.com> <87fvqj2vxz.fsf@xmission.com>
	<20131126142759.GA5473@redhat.com> <20131219125439.GA6379@lst.de>
	<20131220141917.GB27063@redhat.com> <87a9fvqfs4.fsf@xmission.com>
	<52B4D0C6.2000505@zytor.com>
Date: Fri, 20 Dec 2013 17:32:46 -0800
In-Reply-To: <52B4D0C6.2000505@zytor.com> (H. Peter Anvin's message of "Fri,
	20 Dec 2013 15:20:38 -0800")
Message-ID: <87ioujf0ox.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19D9BJfF2lVnYFWu35ilDNee/dArZbHrqc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1381]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in kernel kexec
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 12/20/2013 03:11 PM, Eric W. Biederman wrote:
>> 
>> In that case the chrome folks would simply have to use an ELF format
>> kernel and not a bzImage.
>> 
>
> This is starting to feel like everything is going in the direction of a
> massive feature regression.  bzImage may be weird (it has definitely
> grown organically), but the features that have been added to it have
> generally been for a reason, e.g. kernel relocation and so on.

Stuff and nonsense.  bzImage is just an ugly wrapper around an ELF
image.

I am just arguing that we expose the clean portable underpinnings and
make that work.

It absolutely does not make sense to make a solution that only works for
x86.  ELF is what ever other architecture uses so we absolutely have to
make any feature we build work with ELF.

At a very basic level for this feature ELF is good enough.  bzImage
isn't.

Given that in the worst case distro's will have to package a second
binary of the same kernel in their kernel rpm.  I don't know that there
is any point in supporting anything else except ELF in the kernel.
Given that the package and distribution are going to have to change
anyway to include signing a change in file format hardly seems scary.

But my point above was really that ELF is sufficient for the use case of
doing file based verification base on fd's in addition to the use case
of using detached signatures.  Which is really a long winded way of
saying the argument "But but but my distro only ships a bzImage today"
is a horrible techinical argument.

I am not fundamentally opposed to supporting other file formats but
given that ELF wins on both practical and techincal grounds ELF should
be the primary file format for kexec_file_load.  We can worry about
other file formats once ELF is shown to work.

Eric
