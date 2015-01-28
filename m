Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399AbbA2CKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:10:33 -0500
Received: from [68.232.143.164] ([68.232.143.164]:4743 "EHLO
	esa2.cray.iphmx.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbbA2CK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:10:29 -0500
X-IronPort-AV: E=Sophos;i="5.09,483,1418083200"; 
   d="scan'208";a="187327"
Message-ID: <54C96DA4.10509@cray.com>
Date: Wed, 28 Jan 2015 17:15:48 -0600
From: Frank Zago <fzago@cray.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
CC: <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <HPDD-discuss@ml01.01.org>,
        Eddie Kovsky <ewk@edkovsky.org>, Anil Belur <askb23@gmail.com>
Subject: Re: [HPDD-discuss] [PATCH] staging: lustre: fid: lproc_fid: Removed
 variables that is never used
References: <1422485188-10994-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422485188-10994-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 04:46 PM, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.

s/ar/rc/

> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/staging/lustre/lustre/fid/lproc_fid.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/lustre/lustre/fid/lproc_fid.c b/drivers/staging/lustre/lustre/fid/lproc_fid.c
> index 6a21f07..feb7425 100644
> --- a/drivers/staging/lustre/lustre/fid/lproc_fid.c
> +++ b/drivers/staging/lustre/lustre/fid/lproc_fid.c
> @@ -63,7 +63,6 @@ static int lprocfs_fid_write_common(const char __user *buffer, size_t count,
>   				    struct lu_seq_range *range)
>   {
>   	struct lu_seq_range tmp;
> -	int rc;
>   	char kernbuf[MAX_FID_RANGE_STRLEN];
>
>   	LASSERT(range != NULL);
> @@ -82,7 +81,7 @@ static int lprocfs_fid_write_common(const char __user *buffer, size_t count,
>   	}
>
>   	/* of the form "[0x0000000240000400 - 0x000000028000400]" */
> -	rc = sscanf(kernbuf, "[%llx - %llx]\n",
> +	sscanf(kernbuf, "[%llx - %llx]\n",

I would test rc instead:
   if (rc != 2)
        return -EINVAL;

Regards,
   Frank.
