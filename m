Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaLZXtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 18:49:06 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59417 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaLZXtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 18:49:04 -0500
MIME-Version: 1.0
In-Reply-To: <20141226221444.GA13349@amd>
References: <CAPr7RtWpX_kYiJRRnPVSZrL-U2GqoV5aBPM_AF7xBzV99jzJuw@mail.gmail.com>
 <20141226221444.GA13349@amd>
From: ivo welch <ivo.welch@gmail.com>
Date: Sat, 27 Dec 2014 07:48:42 +0800
X-Google-Sender-Auth: OEK0suMK5V9MwNFp5CmDqTM5UaI
Message-ID: <CAPr7RtVpZ5On3tZaOP0MyLS2CR1xU6GXi1E0C2Yst3_tJm9waw@mail.gmail.com>
Subject: Re: fanotify bug on gdb -- hard crash
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi pavel---I do a complete fresh install on ubuntu 64-bit 14.10 in a
vmware virtual machine.  the gcc version is 4.9.1.  this way I cannot
have made a mistake.  ;-)

the compile is gcc -g -o testfa testfa.c .

the gdb and program must run with root privilege.  without it, it will
just abort on the fd test.

then gdb, do "b main", "run", and step through with 'n's.  you should
see "calling fanotify_mark: fd=3" and then, on the next 'n', it should
never return from the fanotify_mark.  you should not be able to
interrupt.  at this point, you have to pull the plug.

(I think I also trigger this sometimes without gdb, but then it is not
intermittent but replicable.  I started debugging because of this
issue.)

/iaw
----
Ivo Welch (ivo.welch@gmail.com)
http://www.ivo-welch.info/
J. Fred Weston Professor of Finance
Anderson School at UCLA, C519
Director, UCLA Anderson Fink Center for Finance and Investments
Free Finance Textbook, http://book.ivo-welch.info/
Editor, Critical Finance Review, http://www.critical-finance-review.org/



On Sat, Dec 27, 2014 at 6:14 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Fri 2014-12-26 22:45:38, ivo welch wrote:
>> I am not a kernel developer, so forgive the intrusion.
>
> Good bug reports are always welcome.
>
>> I suspect I have found either a bug in gdb (less likely) or a bug in
>> fanotify (more likely).  it is replicable, and the code is almost
>> unchanged from the example in the fanotify man page.  to trigger it,
>> all an su needs to do is to step through the program below with gdb
>> 7.8.1 'n' command, and linux locks up the system pretty hard (reboot
>
> Hard lockup -> this can't be gdb problem.
>
>> required).  I have confirmed the replicability of this issue on a
>> clean arch 2014.12.01 3.17.6-1 system and on a clean ubuntu 14.10
>> system, both VMs created just to check it.  /iaw
>
> Does it need root priviledges to trigger?
>
> Best regards,
>                                                                 Pavel
>
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
