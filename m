Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbaJ3M3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:29:03 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33417 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759157AbaJ3M3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:29:00 -0400
Message-ID: <54522F08.7080005@collabora.co.uk>
Date: Thu, 30 Oct 2014 12:28:56 +0000
From: Simon McVittie <simon.mcvittie@collabora.co.uk>
Organization: Collabora Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>, Andy Lutomirski <luto@amacapital.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>, Daniel Mack <daniel@zonque.org>,
        "alban.crequy" <alban.crequy@collabora.co.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH 00/12] Add kdbus implementation
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz> <20141029231106.GB16548@kroah.com> <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz> <20141029234001.GB16520@kroah.com> <CALCETrXY90YAXA9-GLc0EowmRCtWZzh8br8seiqrzOkmNn8_Hw@mail.gmail.com> <CAG-2HqX9RUQHiF1U_CXiDVVLS-7aUOQdYn7EVNSMZNdbe38cTA@mail.gmail.com>
In-Reply-To: <CAG-2HqX9RUQHiF1U_CXiDVVLS-7aUOQdYn7EVNSMZNdbe38cTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/14 11:52, Tom Gundersen wrote:
> For example, if you want to get the audit identity
> bits, you can now get this attached securely by the kernel, at the
> time the message is sent, rather than having to firest get the peer's
> $PID from SCM_CREDENTIALS and then read the audit identity bits racily
> from /proc/$PID/loginuid and /proc/$PID/sessionid

... which dbus-daemon (traditional D-Bus) deliberately doesn't offer as
a feature, because we are not aware of any way to do that over Unix
sockets without a race condition; and if we can't have it securely, we
don't want to have it at all.
<https://bugs.freedesktop.org/show_bug.cgi?id=83499>
It would be great if kdbus can fix that omission.

Capabilities are in the same boat, and as a result, systemd can't
currently have D-Bus methods that can only be called with CAP_WHATEVER.

> * fewer userspace context switches
[...]
> * fewer message copies in userspace

Readers are probably already aware of this, but note that D-Bus is
designed to be usable between mutually distrusting processes, which is
why we use Unix sockets and a lot of copies, rather than mmap or something.

    S

