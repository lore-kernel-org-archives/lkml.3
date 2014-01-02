Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaABLdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:33:20 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48658 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaABLdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:33:19 -0500
Message-ID: <52C54E7A.3030303@linaro.org>
Date: Thu, 02 Jan 2014 12:33:14 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linux PM mailing list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: very slow IO after resume
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All,

I noticed an issue on the IOs after resuming my laptop.

My mailer thunderbird or the compilations are very slow, often blocked 
in 'D' state. The 'top' shows 81% on wait.

The processes stack are always in when blocked:

[<c164f8ab>] balance_dirty_pages.isra.18+0x3f5/0x4b4
[<c112a2ce>] balance_dirty_pages_ratelimited+0xde/0x100
[<c1120d81>] generic_perform_write+0x141/0x1c0
[<c1120e50>] generic_file_buffered_write+0x50/0x80
[<c1122a4a>] __generic_file_aio_write+0x22a/0x490
[<c1122d13>] generic_file_aio_write+0x63/0xd0
[<c11f5162>] ext4_file_write+0xb2/0x100
[<c117318a>] do_sync_write+0x6a/0xa0
[<c1173dc5>] vfs_write+0xa5/0x1d0
[<c1174277>] SyS_write+0x57/0xa0
[<c1661b37>] syscall_call+0x7/0xb

The kernel is 3.11.0-031100-generic based on ubuntu, I noticed this 
issue on some previous version (since 3.5 AFAIR).
My laptop is a Lenovo X230, SSD 250GB (6Gb/s) and 16GB of RAM.

Is it a known issue ?

Thanks
-- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

