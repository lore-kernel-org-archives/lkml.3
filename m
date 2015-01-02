Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbbABSA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:00:57 -0500
Received: from legacy.ddn.com ([64.47.133.206]:30142 "EHLO legacy.ddn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbbABSA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:00:56 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2015 13:00:56 EST
From: Ashley Pittman <apittman@ddn.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        "HPDD-discuss@lists.01.org" <HPDD-discuss@ml01.01.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [HPDD-discuss] [PATCH] staging: lustre: lustre: include:
	lustre_update.h: Fix for possible null pointer dereference
Thread-Topic: [HPDD-discuss] [PATCH] staging: lustre: lustre: include:
	lustre_update.h: Fix for possible null pointer dereference
Thread-Index: AQHQHW85zpi7gsZOIU+XOSoBi7CSQ5yttegA
Date: Fri, 2 Jan 2015 17:55:50 +0000
Message-ID: <DF2D8745-9436-429C-BE08-555F745E9D11@ddn.com>
References: <1419201831-13878-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1419201831-13878-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.8.103.201]
Content-Type: text/plain; charset="utf-8"
Content-ID: <42FA9EB280ABD4499808573651F2E90E@ddn.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t02I12mY029652


Rickard,

> On 21 Dec 2014, at 22:43, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
> 
> The NULL check was done to late, and there it was a risk
> of a possible null pointer dereference.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
> drivers/staging/lustre/lustre/include/lustre_update.h |    4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lustre/include/lustre_update.h b/drivers/staging/lustre/lustre/include/lustre_update.h
> index 84defce..00e1361 100644
> --- a/drivers/staging/lustre/lustre/include/lustre_update.h
> +++ b/drivers/staging/lustre/lustre/include/lustre_update.h
> @@ -165,12 +165,14 @@ static inline int update_get_reply_buf(struct update_reply *reply, void **buf,
> 	int  result;
> 
> 	ptr = update_get_buf_internal(reply, index, &size);
> +
> +	LASSERT((ptr != NULL && size >= sizeof(int)));
> +
> 	result = *(int *)ptr;
> 
> 	if (result < 0)
> 		return result;
> 
> -	LASSERT((ptr != NULL && size >= sizeof(int)));

This looks odd to me, LASSERT is essentially BUG_ON() so is used for checking logic bugs.  Moving LASSERT calls doesnâ€™t seem the correct way of resolving a logic problem and if youâ€™re doing static analysis it might be more productive to do it this with LASSERT disabled.

> 	*buf = ptr + sizeof(int);
> 	return size - sizeof(int);
> }
> -- 
> 1.7.10.4
> 
> _______________________________________________
> HPDD-discuss mailing list
> HPDD-discuss@lists.01.org
> https://lists.01.org/mailman/listinfo/hpdd-discuss

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
