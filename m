Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3ICObp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:31:45 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:55806 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604Ab3ICObo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:31:44 -0400
Message-ID: <1378218699.1279.7.camel@x61.thuisdomein>
Subject: Re: [PATCH] x86, tsc: downgrade fast calibration failure message
From: Paul Bolle <pebolle@tiscali.nl>
To: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Date: Tue, 03 Sep 2013 16:31:39 +0200
In-Reply-To: <1378217395-1241-1-git-send-email-jerome.oufella@savoirfairelinux.com>
References: <1378217395-1241-1-git-send-email-jerome.oufella@savoirfairelinux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2013 14:31:39.0841 (UTC) FILETIME=[4D832B10:01CEA8B2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-03 at 10:09 -0400, Jerome Oufella wrote:
> As pointed out by Paul Bolle in https://lkml.org/lkml/2012/9/24/221, the
> fast TSC calibration method may fail on some machines and result in an
> error level message that does not reflect the severity of the case.
> 
> Signed-off-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
> ---
> This patch lost momentum and wordsmithing the message was evoked in
> subsequent posts but imho reducing the level does the job just fine.

I've carried an identical patch locally ever since I submitted the patch
referenced by Jerome. Ie, I'm now running v3.11 with that patch applied.
Jerome's commit explanation is a bit terse when compared to my
verbosity, but otherwise I'm fine with this. So:

Acked-by: Paul Bolle <pebolle@tiscali.nl>


Paul Bolle
> ---
>  arch/x86/kernel/tsc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 6ff4924..e518724 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -380,7 +380,7 @@ static unsigned long quick_pit_calibrate(void)
>  			goto success;
>  		}
>  	}
> -	pr_err("Fast TSC calibration failed\n");
> +	pr_info("Fast TSC calibration failed\n");
>  	return 0;
>  
>  success:

