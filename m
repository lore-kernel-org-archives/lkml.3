Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbaEHWlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:41:49 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:65535 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbaEHWls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:41:48 -0400
MIME-Version: 1.0
Date: Thu, 8 May 2014 15:41:48 -0700
Message-ID: <CAGXD9OfpBms0X=C1ZkhgSBTyDLLYLg4s5XWNHeTo8vooL_dtAA@mail.gmail.com>
Subject: not seeing PMIs on AMD 16h family processor with 3.4 or 3.15
From: Prasad Koya <prasad.koya@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

We are not seeing performance monitoring interrupts on AMD eKabini CPU
(family 16h processor). Tried both 3.4 and 3.15 kernels. If there is
more relevant group for this, I could post it there.

When I write to 0xc001_0004 (as given in AMD spec for core perf
counters) counter I see that it overflows fine and it starts counting
back from 0. However I don't see any NMI after oerflow. I also checked
0xc001_0000 and its value is 0x530076, which shows that the NMI is
enabled.


On 3.15 kernel I see this message on console:

[67044.084213] perf interrupt took too long (2529 > 2500), lowering
kernel.perf_event_max_sample_rate to 50000
[146301.023898] Uhhuh. NMI received for unknown reason 31 on CPU 1.
[146301.023952] Do you have a strange power saving mode enabled?
[146301.023991] Dazed and confused, but trying to continue

Anyone else seeing this?

Thank you.
