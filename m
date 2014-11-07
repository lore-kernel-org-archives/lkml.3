Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaKGMnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:43:15 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:47724 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaKGMnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:43:14 -0500
Message-ID: <545CBE5E.3050906@cogentembedded.com>
Date: Fri, 07 Nov 2014 15:43:10 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alban Bedel <albeu@free.fr>, linux-kernel@vger.kernel.org
CC: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 1/2] MIPS: FW: Fix parsing u-boot environment
References: <1415359381-27257-1-git-send-email-albeu@free.fr>
In-Reply-To: <1415359381-27257-1-git-send-email-albeu@free.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/7/2014 2:23 PM, Alban Bedel wrote:

> When reading u-boot's key=value pairs it should skip the '=' and not
> use the next argument.

> Signed-off-by: Alban Bedel <albeu@free.fr>
> ---
>   arch/mips/fw/lib/cmdline.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/arch/mips/fw/lib/cmdline.c b/arch/mips/fw/lib/cmdline.c
> index ffd0345..cc5d168 100644
> --- a/arch/mips/fw/lib/cmdline.c
> +++ b/arch/mips/fw/lib/cmdline.c
> @@ -68,7 +68,7 @@ char *fw_getenv(char *envname)
>   					result = fw_envp(index + 1);
>   					break;
>   				} else if (fw_envp(index)[i] == '=') {
> -					result = (fw_envp(index + 1) + i);
> +					result = (fw_envp(index) + i + 1);

    Perhaps it's time to drop the useless outer parens?

WBR, Sergei

