Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab3CLU05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:26:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36586 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028Ab3CLU04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:26:56 -0400
X-IronPort-AV: E=Sophos;i="4.84,833,1355126400"; 
   d="scan'208";a="28881864"
Message-ID: <513F8F80.1070409@codeaurora.org>
Date: Tue, 12 Mar 2013 13:26:40 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 07/11] ssbi: Use regular init level
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org> <1363113716-25897-1-git-send-email-davidb@codeaurora.org> <1363113716-25897-8-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1363113716-25897-8-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/13 11:41, David Brown wrote:
> With device tree, and deferred probe, it is no longer necessary to
> make sure that the ssbi bus driver is initialized very early.  Restore
> to a regular module_init().
>
> Signed-off-by: David Brown <davidb@codeaurora.org>
> ---
>  drivers/ssbi/ssbi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/ssbi/ssbi.c b/drivers/ssbi/ssbi.c
> index 7ae8925..6878e55 100644
> --- a/drivers/ssbi/ssbi.c
> +++ b/drivers/ssbi/ssbi.c
> @@ -379,7 +379,7 @@ static int __init msm_ssbi_init(void)
>  {
>  	return platform_driver_register(&msm_ssbi_driver);
>  }
> -postcore_initcall(msm_ssbi_init);
> +module_init(msm_ssbi_init);
>  
>  static void __exit msm_ssbi_exit(void)
>  {

With this change we can use module_platform_driver() too.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

