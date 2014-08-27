Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbaH0BgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:36:05 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:35878 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbaH0BgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:36:04 -0400
MIME-Version: 1.0
From: Daniel Peebles <pumpkingod@gmail.com>
Date: Tue, 26 Aug 2014 21:35:42 -0400
Message-ID: <CANaM3xDEJGW-eeC_Q=b6U8+5404LjVMKqgmQ6DStfTjFzE-5xg@mail.gmail.com>
Subject: 3.17 regression: building with cwd outside of source root fails
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm a kernel newbie so I feel a bit out of place here, but I wanted to
draw attention to this bug I filed:
https://bugzilla.kernel.org/show_bug.cgi?id=83251. It fails in both
3.17-rc1 and -rc2, and the same workflow worked fine with 3.16.

I *think* the problem was introduced by the new references to $PWD in
the makefiles in commit 00a2430ff07d4e0e0e7e24e02fd8adede333b797
(https://github.com/torvalds/linux/commit/00a2430ff07d4e0e0e7e24e02fd8adede333b797
for the lazy), since my working directory isn't the main source tree.
Then again, it looks like there were already some mentions of $PWD
before that commit, so I'm not too sure.

Anyway, I'd appreciate feedback and/or hints for how to better
diagnose this or advice as to what the correct fix is.

Thanks,
Dan
