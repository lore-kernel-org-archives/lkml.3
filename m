Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab3A1Dni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:43:38 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:44886 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab3A1Dnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:43:35 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: serge.hallyn@canonical.com, akpm@linux-foundation.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <1359342541-383-1-git-send-email-gaofeng@cn.fujitsu.com>
Date: Sun, 27 Jan 2013 19:43:25 -0800
In-Reply-To: <1359342541-383-1-git-send-email-gaofeng@cn.fujitsu.com> (Gao
	feng's message of "Mon, 28 Jan 2013 11:09:01 +0800")
Message-ID: <87bocayntu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/9iy9E6a3feLukQhIfeoY2BmzUbcrFW5Q=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gao feng <gaofeng@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] userns: Allow the unprivileged users to mount mqueue fs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gao feng <gaofeng@cn.fujitsu.com> writes:

> This patch allow the unprivileged user to mount mqueuefs in
> user ns.
>
> If two userns share the same ipcns,the files in mqueue fs
> should be seen in both these two userns.
>
> If the userns has its own ipcns,it has its own mqueue fs too.
> ipcns has already done this job well.

I am a little dense.  When does userspace actually mount a mqueuefs?
My impression was that user space never needed to mount and actually
never could mount a mqueuefs.  MS_NO_USER isn't set so mounting a
mqueuefs is possible but when does it happen and why?

I am trying to think through the logic here and I think this is safe
but since I don't understand why we would mount an mqueue fs I am
having trouble verifying that there are no silly reasons why this might
be a bad idea.

But from what I can tell so far this seems like a good patch.

Eric


> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  ipc/mqueue.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 71a3ca1..023c986 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -1383,6 +1383,7 @@ static struct file_system_type mqueue_fs_type = {
>  	.name = "mqueue",
>  	.mount = mqueue_mount,
>  	.kill_sb = kill_litter_super,
> +	.fs_flags = FS_USERNS_MOUNT,
>  };
>  
>  int mq_init_ns(struct ipc_namespace *ns)
