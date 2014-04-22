Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaDVPY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:24:26 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40935 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaDVPYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:24:22 -0400
MIME-Version: 1.0
In-Reply-To: <CANq1E4TPPcdD-8FF_Kc=r44Vrd51Vmt-OVu+EtCC-oEzXkvJvg@mail.gmail.com>
References: <cover.1398097304.git.luto@amacapital.net> <430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
 <CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
 <20140422143152.GA23716@amd.pavel.ucw.cz> <CANq1E4TPPcdD-8FF_Kc=r44Vrd51Vmt-OVu+EtCC-oEzXkvJvg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 22 Apr 2014 08:24:00 -0700
Message-ID: <CALCETrWN_g50nDitvUSmoL6Ho0pHXEMXiqCVHeU53uZc5hN+1g@mail.gmail.com>
Subject: Re: [RFC 2/2] fs,proc: Respect FMODE_WRITE when opening /proc/pid/fd/N
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 8:19 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Tue, Apr 22, 2014 at 4:31 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> Such as here?
>>
>> http://www.securityfocus.com/archive/1/507386
>
> Thanks, that's the first real example someone mentioned.
>
> Quoted from your link:
>
>> The reopen does check the inode permission, but it does not require
>> you have any reachable path to the file. Someone _might_ use that as
>> a traditional unix security mechanism, but if so it's probably quite rare.
>
> In other words, the bug you describe is that /proc/pid/fd/ allows
> access to objects without a reachable path to the only _real_
> filesystem link. But isn't the same true for openat()?

I don't think so.  openat doesn't work on fds for things that aren't
directories.

--Andy
