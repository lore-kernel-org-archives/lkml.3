Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381Ab3GPPzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:55:32 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:58558 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab3GPPza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:55:30 -0400
MIME-Version: 1.0
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 16 Jul 2013 21:24:49 +0530
Message-ID: <CALkWK0k2BsoxwMLHSWmmrFXkvMBiWDG1b0NXrfR6i95=tFPMXw@mail.gmail.com>
Subject: [QUERY] User-Mode Linux and /dev/tty*
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So, I was trying to boot User-Mode Linux with a modern rootfs with
systemd on it, and found that it wouldn't present me a prompt.  I dug
further, and found out that getty is not able to open /dev/tty1; I
then tried the console-getty.service (which uses /dev/console), and it
worked.  The reason it doesn't work out of the box is that systemd is
not able to figure out whether or not a virtual console subsystem is
present: /dev/tty0 is present for some reason (although I'm not sure
it's a virtual console), and this confuses systemd.

So, my question is: does um Linux have a virtual console subsystem?
If so, then why doesn't it seem to work?  If not, why does /dev/tty0
exist?

Thanks.
