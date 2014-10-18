Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaJRLL3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 07:11:29 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:59790 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaJRLL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 07:11:29 -0400
MIME-Version: 1.0
Date: Sat, 18 Oct 2014 16:41:26 +0530
Message-ID: <CAFxy--b+j86kn6Ttc+qTTi4chDkKbrmSAxEsS7_CnzuabJAZfQ@mail.gmail.com>
Subject: threadirqs and kthreadd_task
From: ajay kanala <ajaykanala321@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have been trying to enable "threadirqs" command line option on
3.10.12 kernel and kernel crashes with NULL pointer access for
kthreadd_task in wake_up_process function:

[    0.000000] Call Trace:
[    0.000000] [<8005544c>] wake_up_process+0xc/0x48
[    0.000000] [<8004c1b8>] kthread_create_on_node+0x64/0xc4
[    0.000000] [<8006d338>] __setup_irq+0x130/0x634
[    0.000000] [<8006d89c>] setup_irq+0x60/0xb4
[    0.000000] [<8050267c>] icu_of_init+0x1f8/0x2f8
[    0.000000] [<80517b30>] of_irq_init+0x2c8/0x304
[    0.000000] [<805007bc>] start_kernel+0x218/0x3a4

But as far as i see, kthreadd_task is initialized in start_kernel -->
rest_init function which is much later than setting up interrupts (
init_IRQ ):

So my question is, how are systems working which enabled "threadirqs"
command line option enabled ( the code flow seems similar even on 3.17
kernel ). Am i missing the obvious?

thanks for pointers

-- Ajay
