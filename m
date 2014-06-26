Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaFZVDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:03:41 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:51538 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaFZVDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:03:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140626204303.GE11136@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-9-git-send-email-vgoyal@redhat.com> <20140626204303.GE11136@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 26 Jun 2014 14:03:17 -0700
Message-ID: <CALCETrU8mixFxpS2Bt2Q7S08zUFxZwE1zfqHw8PEetqewgR7RQ@mail.gmail.com>
Subject: Re: [PATCH 08/15] kexec: New syscall kexec_file_load() declaration
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Borislav Petkov <bp@alien8.de>,
        dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 1:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Jun 26, 2014 at 04:33:37PM -0400, Vivek Goyal wrote:
>> This is the new syscall kexec_file_load() declaration/interface. I have
>> reserved the syscall number only for x86_64 so far. Other architectures
>> (including i386) can reserve syscall number when they enable the support
>> for this new syscall.
>>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> CC: linux-api@vger.kernel.org
>
> +.BR KEXEC_FILE_NO_INITRAMFS
> +Loading initrd/initramfs is optional. Specify this flag if no initramfs
> +is being loaded. If this flag is set, kernel will ignore the value passed
> +in

This seems pointless.  Why not just pass -1 for initrd_fd to indicate
that no initrd is needed?

--Andy
