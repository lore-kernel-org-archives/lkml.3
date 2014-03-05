Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbaCERLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:11:32 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50389 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaCERLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:11:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Cochran <richardcochran@gmail.com>
Cc: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, <stable@vger.kernel.org>
References: <74f5a436ebf5c13ed89a81c47ba09a6549e385f6.1394035568.git.richardcochran@gmail.com>
Date: Wed, 05 Mar 2014 09:11:17 -0800
In-Reply-To: <74f5a436ebf5c13ed89a81c47ba09a6549e385f6.1394035568.git.richardcochran@gmail.com>
	(Richard Cochran's message of "Wed, 5 Mar 2014 17:10:52 +0100")
Message-ID: <877g887eq2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/G2yt11YbmBkP3JIy8JwQu79QqTJ87s1c=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0039]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Cochran <richardcochran@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kernfs: fix off by one error.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Cochran <richardcochran@gmail.com> writes:

> The hash values 0 and 1 are reserved for magic directory entries, but
> the code only prevents names hashing to 0. This patch fixes the test
> to also prevent hash value 1.
>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Cc: <stable@vger.kernel.org>
> ---
>  fs/kernfs/dir.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> index bd6e18b..39c0143 100644
> --- a/fs/kernfs/dir.c
> +++ b/fs/kernfs/dir.c
> @@ -37,7 +37,7 @@ static unsigned int kernfs_name_hash(const char *name, const void *ns)
>  	hash = (end_name_hash(hash) ^ hash_ptr((void *)ns, 31));
>  	hash &= 0x7fffffffU;
>  	/* Reserve hash numbers 0, 1 and INT_MAX for magic directory entries */
> -	if (hash < 1)
> +	if (hash < 2)
>  		hash += 2;
>  	if (hash >= INT_MAX)
>  		hash = INT_MAX - 1;
