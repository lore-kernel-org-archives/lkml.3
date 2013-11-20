Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3KTAxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:53:23 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49827 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3KTAxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:53:22 -0500
X-AuditID: 85900ec0-d0927b9000001514-f0-528c07fd779b
Message-ID: <528C07FB.4090904@hitachi.com>
Date: Wed, 20 Nov 2013 09:53:15 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, masami.hiramatsu.pt@hitachi.com,
        hidehiro.kawai.ez@hitachi.com, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip 0/2] ftrace: Introduce the new I/F "nr_saved_cmdlines"
References: <20131108042652.26950.32013.stgit@yunodevel>
In-Reply-To: <20131108042652.26950.32013.stgit@yunodevel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Would you review this patch set?

Thanks,
Yoshihiro YUNOMAE

(2013/11/08 13:26), Yoshihiro YUNOMAE wrote:
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
> ---
>
> Yoshihiro YUNOMAE (2):
>        ftrace: Make saved_cmdlines use seq_read
>        ftrace: Introduce nr_saved_cmdlines I/F
>
>
>   kernel/trace/trace.c |  296 +++++++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 241 insertions(+), 55 deletions(-)
>

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


