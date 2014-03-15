Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbaCOPJl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 11:09:41 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:42340 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaCOPJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 11:09:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXD9OcJZGPaqy+=p7_gio_vRXVxrK73LjSjteto6iiqo2a=nA@mail.gmail.com>
References: <CAGXD9OcJZGPaqy+=p7_gio_vRXVxrK73LjSjteto6iiqo2a=nA@mail.gmail.com>
Date: Sat, 15 Mar 2014 08:09:38 -0700
Message-ID: <CAGXD9OeHfSNER1zny2FhXqsa=Ep0gi81OXD9uPPGNk5G0eTB4A@mail.gmail.com>
Subject: Fwd: vmcore-dmesg ends with "No program header covering vaddr"
From: Prasad Koya <prasad.koya@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding to lkml. If there is any other relevant mailing list, pl let me know.


---------- Forwarded message ----------
From: Prasad Koya <prasad.koya@gmail.com>
Date: Fri, Mar 14, 2014 at 10:39 PM
Subject: vmcore-dmesg ends with "No program header covering vaddr"
To: kexec@lists.infradead.org


Hi

I'm increasing dmesg buffer size at runtime by passing log_buf_len=1M
(or 512K) at command line. At compile time, I have LOG_BUF_LEN as
256K. However, when this kernel crashes (crashkernel set at 64M),
vmcore-dmesg fails with below error.

No program header covering vaddr 0xffff88013ff00000found kexec bug?

Am I missing something here?

Thank you.

Here are some debugs I added to kernel. This is with 3.4 kernel and
I've tried with kexec-tools-2.0.4.

[    0.000000] log_buf_len_setup: log_buf_len 262144 new 1048576
ffffffff8170b140
[    0.000000] setup_log_buf: early 1 262144 new_log_buf_len 1048576
[    0.000000] log_buf_len: 1048576 ffff880037d58000
[    0.000000] early log buf free: 258671(98%)
[    0.000000] setup_log_buf: early 0 1048576 new_log_buf_len 0
[    0.503752] log_buf_kexec_setup: lbl 1048576 new 0 ffffffff816198c4
logbuf ffff880037d58000
In kdump, running vmcore_dmesg /proc/vmcore
No program header covering vaddr 0xffff88013ff00000found kexec bug?
