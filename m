Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3J3Vmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:42:43 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39369 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3J3Vml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:42:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <20131029220939.GA23060@kroah.com>
Date: Wed, 30 Oct 2013 14:42:35 -0700
In-Reply-To: <20131029220939.GA23060@kroah.com> (Greg KH's message of "Tue, 29
	Oct 2013 15:09:39 -0700")
Message-ID: <87wqku1lmc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+cI7BGOxz2l8NinrRX/wEmaZVHm+y3Kiw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0066]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysfs: move assignment to be under lock in sysfs_remove_dir()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Linus noticed that the assignment of sd isn't protected by the lock in
> sysfs_remove_dir(), so move the assignment of the variable under the
> lock to be safe.
>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

> ---
>
> Tejun, any objection to this patch?  You consolidated the locks back in
> 2007 on this function, and nothing has changed there since then, so odds
> are it's not a problem, but nice to be safe, right?
>
>  fs/sysfs/dir.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index eab59de4..2609f934 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -856,9 +856,10 @@ void sysfs_remove(struct sysfs_dirent *sd)
>   */
>  void sysfs_remove_dir(struct kobject *kobj)
>  {
> -	struct sysfs_dirent *sd = kobj->sd;
> +	struct sysfs_dirent *sd;
>  
>  	spin_lock(&sysfs_assoc_lock);
> +	sd = kobj->sd;
>  	kobj->sd = NULL;
>  	spin_unlock(&sysfs_assoc_lock);
>  
