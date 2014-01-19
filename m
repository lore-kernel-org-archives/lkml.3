Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaASLf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 06:35:59 -0500
Received: from science.horizon.com ([71.41.210.146]:14424 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752075AbaASLf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 06:35:57 -0500
Date: 19 Jan 2014 06:35:55 -0500
Message-ID: <20140119113555.30961.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: nate@thatsmathematics.com
Subject: Re: math_state_restore and kernel_fpu_end disable interrupts?
Cc: adilger@dilger.ca, jack@suse.cz, linux@horizon.com,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

THANK YOU!

I've been having a problem with ext4 metadata checksums, which use SSE
for large blocks, and traced it to kernel_fpu_end() disabling interrupts,
but had paused to debug this (I assumed well-tested) piece of kernel
code before pushing it harder.

(Search October-December LKML archives for "3.11.4: kernel BUG at
fs/buffer.c:1268".")

No, I'm pretty sure it's a real bug.  At least, it's biting me on the
ass.

