Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3JSUdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 16:33:10 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:46876 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab3JSUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 16:33:09 -0400
MIME-Version: 1.0
Date: Sun, 20 Oct 2013 00:33:07 +0400
X-Google-Sender-Auth: WQHzv0i2s-1_MBdQBabzJ3NDeyY
Message-ID: <CAG5DWojOsLa_SXaLR8_z4FVchqzwQM4vCNC_MUg27Z918ExPzw@mail.gmail.com>
Subject: adjust /proc/PID/oom_score_adj with CAP_SYS_RESOURCE
From: Azat Khuzhin <a.khuzhin@semrush.com>
To: open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I needed in adjusting /proc/PID/oom_score_adj to disable oom killer,
but I didn't want to add suid/or run from root that binary.

I decided to use CAP_SYS_RESOURCE. However it didn't work.

I gdb/strace/printk a lot, and finally found the reason,
the process can't open this file for writing because pid_revalidate()
change i_uid/i_gid for it to GLOBAL_ROOT_UID/GID.
And to bypass this check I must to use CAP_DAC_OVERRIDE, which is not so good,
because this will allow more capabilities than I need for that binary.

Is this works by design,
and/or is there another way to do this without suid/root?

Thanks!

-- 
Respectfully
Azat Khuzhin
