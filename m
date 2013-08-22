Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3HVUHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:07:22 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:58549 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3HVUHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:07:20 -0400
MIME-Version: 1.0
From: Corey <corey@x64.co>
Date: Thu, 22 Aug 2013 16:06:59 -0400
X-Google-Sender-Auth: 82MqGBsfD5OOKrslRcUg8US_rhY
Message-ID: <CAEi9g3Ef-Ny5UjZJpYpX5XPeY42yAinh_fCKPTF+gEWHrqp2_g@mail.gmail.com>
Subject: Hanging ps output after crash
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello mailing list,

Earlier today I had Eclipse/Tomcat crash and thereafter I was unable
to use ps or other process utilities. Specifically, the output of ps,
top, w, and so on would hang and I was unable to terminate the
process. `ps` (with no arguments) and `pstree` remained working,
however. After some discussion in my distro-specific IRC channel,
someone suggested I should reach out to this mailing list.

I am using Arch Linux on kernel 3.10.7-1-ARCH SMP PREEMPT x86_64

Here is the output of `strace ps aux`: http://pastebin.com/jaFCN3YL
(large text file)

And the output of /proc/<pid>/stack:
[<ffffffff81279a64>] call_rwsem_down_read_failed+0x14/0x30
[<ffffffff8114cdb2>] __access_remote_vm+0x42/0x1c0
[<ffffffff8114d240>] access_process_vm+0x50/0x70
[<ffffffff811f069a>] proc_pid_cmdline+0x8a/0x120
[<ffffffff811ef57f>] proc_info_read+0x8f/0xe0
[<ffffffff8118b148>] vfs_read+0x98/0x170
[<ffffffff8118bc39>] SyS_read+0x49/0xa0
[<ffffffff814cfaef>] tracesys+0xe1/0xe6
[<ffffffffffffffff>] 0xffffffffffffffff

When I tried to reboot, the system crashed. As I had no good way to
collect the contents of the dump, I took a few pictures (the
widescreen necessitated two pictures, though I doubt the latter is of
much use) and hosted them on imgur: http://imgur.com/a/cqfOH.

I hope this information is suitable and that I have not posted here in
error. Please keep in mind that I am not subscribed to this mailing
list.

Thanks,

Corey
