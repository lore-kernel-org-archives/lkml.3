Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398AbaDVRFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:05:46 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:58052 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbaDVRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:05:44 -0400
MIME-Version: 1.0
In-Reply-To: <CANq1E4TZHwyesFSsfKe8bE+z-H9aXs49Wd5EpkFFX08AK4onGg@mail.gmail.com>
References: <cover.1398097304.git.luto@amacapital.net> <430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
 <CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
 <20140422143152.GA23716@amd.pavel.ucw.cz> <CANq1E4TPPcdD-8FF_Kc=r44Vrd51Vmt-OVu+EtCC-oEzXkvJvg@mail.gmail.com>
 <CALCETrWN_g50nDitvUSmoL6Ho0pHXEMXiqCVHeU53uZc5hN+1g@mail.gmail.com> <CANq1E4TZHwyesFSsfKe8bE+z-H9aXs49Wd5EpkFFX08AK4onGg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 22 Apr 2014 10:05:23 -0700
Message-ID: <CALCETrWCYB0fvCMYRySqbpYu42ph1cQfF3yVNDicvtHHSASp1A@mail.gmail.com>
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

On Tue, Apr 22, 2014 at 9:44 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Tue, Apr 22, 2014 at 5:24 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Tue, Apr 22, 2014 at 8:19 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>>> In other words, the bug you describe is that /proc/pid/fd/ allows
>>> access to objects without a reachable path to the only _real_
>>> filesystem link. But isn't the same true for openat()?
>>
>> I don't think so.  openat doesn't work on fds for things that aren't
>> directories.
>
> Sorry, I wasn't precise enough: I meant the same 'leak' occurs if you
> keep a dir-fd on the directory in question _before_ it is set to 0600.
> Just like the example race keeps a file-fd to the file in question. So
> after the directory is set to 0600 you can use that dir-fd via
> openat() to avoid the whole path-lookup just like you do it via /proc.
>

I think this doesn't work -- fds pointing at directories don't capture
execute permission the way fds pointing at files can capture write
permission.  This is similar to the way that ls fails if you chmod 000
'.'.  Yes, it's weird.

--Andy
