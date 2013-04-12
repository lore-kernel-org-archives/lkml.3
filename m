Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3DLO2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 10:28:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22279 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3DLO2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 10:28:54 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=tLUlnkoJZcZI9ocdGARlSQ==:17 a=c11ml42nfjYA:10 a=wom5GMh1gUkA:10 a=mDLtzay-EBQA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=hBqU3vQJAAAA:8 a=aPza9ZebU9UA:10 a=40MIqcmNAAAA:8 a=DfNHnWVPAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=Keo2ReyYu9XSrpqQYO4A:9 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=-tENaG0q7zQA:10 a=lBRciGGoxdUA:10 a=tLUlnkoJZcZI9ocdGARlSQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.114.148.7
Date: Fri, 12 Apr 2013 09:29:49 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: acct: kfree, also set related variable to NULL
 after kfree
Message-ID: <20130412142949.GA21714@austin.hallyn.com>
References: <51652E31.7090806@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51652E31.7090806@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chen Gang (gang.chen@asianux.com):
> 
>   after kfree acct, also set ns->bacct to NULL.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  kernel/acct.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/acct.c b/kernel/acct.c
> index 85389fe..91a23eb 100644
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -332,6 +332,7 @@ void acct_exit_ns(struct pid_namespace *ns)
>  	spin_lock(&acct_lock);
>  	if (acct->file != NULL)
>  		acct_file_reopen(acct, NULL, NULL);
> +	ns->bacct = NULL;
>  	spin_unlock(&acct_lock);
>  
>  	kfree(acct);
> -- 
> 1.7.7.6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
