Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaEZHU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:20:26 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60340 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaEZHUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:20:25 -0400
X-AuditID: 85900ec0-d1328b9000001514-e9-5382eb36736c
Message-ID: <5382EB36.2060501@hitachi.com>
Date: Mon, 26 May 2014 16:20:22 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH V2 0/2] ftrace: Introduce the new I/F "nr_saved_cmdlines"
References: <20140220084428.3839.59555.stgit@yunodevel>
In-Reply-To: <20140220084428.3839.59555.stgit@yunodevel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Would you review this patch set?

Thanks,
Yoshihiro YUNOMAE

(2014/02/20 17:44), Yoshihiro YUNOMAE wrote:
> Hi,
>
> This patch set introduces the new I/F "nr_saved_cmdlines" for increasing
> the number of saved cmdlines. Current saved_cmdlines can store just 128 command
> names and PIDs, but process names are often lost like <...> when we read trace
> data. If the process exists, we can get the name by using ps command. However,
> if the process already has not existed, we cannot get the name.
>
> To solve this issue, we introduce the new I/F "nr_saved_cmdlines" to expand
> the max number of saved command line names. This I/F is very simple.
> If we write a number to nr_saved_cmdlines, the number of command name will be
> stored. And, if we read the I/F, we can get current maximum number of command
> name. The default number is 128 which is current default number, so this patch
> does not change the usage of memory for saved_cmdlines when we boot kernel.
>
> Thanks!
>
> Changes in V2:
> - Fix a racing problem of savedcmd between saved_cmdlines I/F and
>    nr_saved_cmdlines I/F. If one reads saved_cmdlines and writes a value to
>    nr_saved_cmdlines at the same time, then the write returns -EBUSY. [2/2]
>
> ---
>
> Yoshihiro YUNOMAE (2):
>        ftrace: Make saved_cmdlines use seq_read
>        ftrace: Introduce nr_saved_cmdlines I/F
>
>
>   kernel/trace/trace.c |  316 +++++++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 261 insertions(+), 55 deletions(-)
>

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


