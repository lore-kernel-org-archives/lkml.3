Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbbATNxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:53:18 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:49302 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbATNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:53:16 -0500
Message-ID: <54BE5DC8.70706@gmail.com>
Date: Tue, 20 Jan 2015 14:53:12 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de,
        ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no,
        jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: mtk.manpages@gmail.com, daniel@zonque.or, dh.herrmann@gmail.com,
        tixxdz@opendz.org, Daniel Mack <daniel@zonque.org>,
        Johannes Stezenbach <js@sig21.net>
Subject: Re: [PATCH 01/13] kdbus: add documentation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 08:16 PM, Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel@zonque.org>
> 
> kdbus is a system for low-latency, low-overhead, easy to use
> interprocess communication (IPC).
> 
> The interface to all functions in this driver is implemented via ioctls
> on files exposed through a filesystem called 'kdbusfs'. The default
> mount point of kdbusfs is /sys/fs/kdbus. This patch adds detailed
> documentation about the kernel level API design.

I have some details feedback on the contents of this file, and some 
bigger questions. I'll split them out into separate mails.

So here, the bigger, general questions to start with. I've arrived late 
to this, so sorry if they've already been discussed, but the answers to 
some of the questions should actually be in this file, I would have 
expected.

This is an enormous and complex API. Why is the API ioctl() based,
rather than system-call-based? Have we learned nothing from the hydra
that the futex() multiplexing syscall became? (And kdbus is an order
of magnitude more complex, by the look of things.) At the very least,
a *good* justification of why the API is ioctl()-based should be part
of this documentation file.

An observation: The documentation below is substantial, but this API is 
enormous, so the documentation still feels rather thin. What would 
really help would be some example code in the doc. 

And on the subject of code examples... Are there any (prototype) 
working user-space applications that exercise the current kdbus 
implementation? That is, can I install these kdbus patches, and
then find a simple example application somewhere that does
something to exercise kdbus?

And then: is there any substantial real-world application (e.g., a 
full D-Bus port) that is being developed in tandem with this kernel
side patch? (I don't mean a user-space library; I mean a seriously
large application.) This is an incredibly complex API whose
failings are only going to become evident through real-world use.
Solidifying an API in the kernel and then discovering the API
problems later when writing real-world applications would make for
a sad story. A story something like that of inotify, an API which 
is an order of magnitude less complex than kdbus. (I can't help but
feel that many of inotify problems that I discuss at 
https://lwn.net/Articles/605128/ might have been fixed or mitigated 
if a few real-world applications had been implemented before the
API  was set in stone.)

> +For a kdbus specific userspace library implementation please refer to:
> +  http://cgit.freedesktop.org/systemd/systemd/tree/src/systemd/sd-bus.h

Is this library intended just for systemd? More generally, is there an 
intention to provide a general purpose library API for kdbus? Or is the
intention that each application will roll a library suitable to its
needs? I think an answer to that question would be useful in this 
Documentation file.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
