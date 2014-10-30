Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbaJ3LDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:03:02 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:52853 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162AbaJ3LDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:03:00 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.172.182]
In-Reply-To: <3546486.lOZcZMmXYe@wuerfel>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-3-git-send-email-gregkh@linuxfoundation.org> <3546486.lOZcZMmXYe@wuerfel>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 30 Oct 2014 12:02:39 +0100
Message-ID: <CAG-2HqV_mXyARMs=9GOpbCBHPU+2XMkDcm=sGekYnnujNPAYqQ@mail.gmail.com>
Subject: Re: kdbus: add header file
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Tejun Heo <tj@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>,
        Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        Daniel Mack <daniel@zonque.org>,
        "alban.crequy" <alban.crequy@collabora.co.uk>,
        "javier.martinez" <javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 9:20 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> I think in general, using enum is great, but for ioctl command numbers,
> we probably want to have defines so the user space implementation can
> use #ifdef to see if the kernel version that it is being built for
> knows a particular command.

Does that make sense for the first version? I agree that we should use
 #define to allow #ifdef for when we add more ioctls in the future,
but these ioctls will always exist...

The nice thing about enums is of course that it helps with debugging
as gdb can show the string representation rather than the number,
because in contrast to #defines, an enum is something the compliler
knows about.

Cheers,

Tom
