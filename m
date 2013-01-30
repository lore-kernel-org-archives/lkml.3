Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab3A3BwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:52:14 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:34362 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3A3BwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:52:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51087878.4010109@cn.fujitsu.com>
Date: Tue, 29 Jan 2013 17:52:03 -0800
In-Reply-To: <51087878.4010109@cn.fujitsu.com> (Zhang Yanfei's message of
	"Wed, 30 Jan 2013 09:33:44 +0800")
Message-ID: <87boc74ev0.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18K9vEILav8D+gqu1t5P6emMJJIGaX3mMk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] KEXEC: Get rid of duplicate check for hole_end
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Yanfei <zhangyanfei@cn.fujitsu.com> writes:

> hole_end has been checked to make sure it is <= crash_res.end in the
> while condition check, so the if condition check is duplicate.

That test is definitely a duplicate.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  kernel/kexec.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 5e4bd78..c2826fc 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -497,8 +497,6 @@ static struct page *kimage_alloc_crash_control_pages(struct kimage *image,
>  
>  		if (hole_end > KEXEC_CRASH_CONTROL_MEMORY_LIMIT)
>  			break;
> -		if (hole_end > crashk_res.end)
> -			break;
>  		/* See if I overlap any of the segments */
>  		for (i = 0; i < image->nr_segments; i++) {
>  			unsigned long mstart, mend;
