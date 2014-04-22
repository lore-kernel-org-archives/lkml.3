Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbaDVPTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:19:54 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57463 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115AbaDVPTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:19:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140422143152.GA23716@amd.pavel.ucw.cz>
References: <cover.1398097304.git.luto@amacapital.net>
	<430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
	<CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
	<20140422143152.GA23716@amd.pavel.ucw.cz>
Date: Tue, 22 Apr 2014 17:19:42 +0200
Message-ID: <CANq1E4TPPcdD-8FF_Kc=r44Vrd51Vmt-OVu+EtCC-oEzXkvJvg@mail.gmail.com>
Subject: Re: [RFC 2/2] fs,proc: Respect FMODE_WRITE when opening /proc/pid/fd/N
From: David Herrmann <dh.herrmann@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andy Lutomirski <luto@amacapital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Apr 22, 2014 at 4:31 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Such as here?
>
> http://www.securityfocus.com/archive/1/507386

Thanks, that's the first real example someone mentioned.

Quoted from your link:

> The reopen does check the inode permission, but it does not require
> you have any reachable path to the file. Someone _might_ use that as
> a traditional unix security mechanism, but if so it's probably quite rare.

In other words, the bug you describe is that /proc/pid/fd/ allows
access to objects without a reachable path to the only _real_
filesystem link. But isn't the same true for openat()?

Thanks
David
