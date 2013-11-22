Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3KVRpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:45:30 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:57409 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3KVRpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:45:14 -0500
MIME-Version: 1.0
In-Reply-To: <20131122153349.GH4046@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
	<8761rl73s7.fsf@xmission.com>
	<20131122015518.GA31921@redhat.com>
	<CAMuHMdUVvhKLBfZo2gBf=FoQxMEM42yzBjYS8r5sVfXgp940ng@mail.gmail.com>
	<alpine.LRH.2.00.1311221429470.9932@twin.jikos.cz>
	<20131122134600.GC4046@redhat.com>
	<alpine.LNX.2.00.1311221449120.22082@pobox.suse.cz>
	<20131122153349.GH4046@redhat.com>
Date: Fri, 22 Nov 2013 09:45:13 -0800
X-Google-Sender-Auth: GtA3FrlDMcFvo06HKoSmH3jnEPY
Message-ID: <CAGXu5jJVskjN8YAh-QxS08CLGHgRvLq3Hdef2rg2gnxMCz_BRw@mail.gmail.com>
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
From: Kees Cook <keescook@chromium.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Geert Uytterhoeven <geert@linux-m68k.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 7:33 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Nov 22, 2013 at 02:50:43PM +0100, Jiri Kosina wrote:
>> On Fri, 22 Nov 2013, Vivek Goyal wrote:
>>
>> > > OTOH, does this feature make any sense whatsover on architectures that
>> > > don't support secure boot anyway?
>> >
>> > I guess if signed modules makes sense, then being able to kexec signed
>> > kernel images should make sense too, in general.
>>
>> Well, that's really a grey zone, I'd say.
>>
>> In a non-secureboot environment, if you are root, you are able to issue
>> reboot into a completely different, self-made kernel anyway, independent
>> on whether signed modules are used or not.
>
> That's a good poing. Frankly speaking I don't know if there is a good
> use case to allow loading signed kernels only or not.
>
> Kees mentioned that he would like to know where the kernel came from
> and whether it came from trusted disk or not. So he does seem to have
> a use case where he wants to launch only trusted kernel or deny execution.

Correct. Though to clarify, Chrome OS doesn't use UEFI SecureBoot: we
have a different solution that uses dm-verity to give us a trusted
read-only root filesystem. As long as things live on that filesystem,
we trust them. (This is why finit_module was added, and why I wanted
to make sure kexec used fd instead of "just" a memory blob.)

-Kees

-- 
Kees Cook
Chrome OS Security
