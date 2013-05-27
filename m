Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3E0KTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:19:10 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:43837 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab3E0KTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:19:08 -0400
Message-ID: <51A33317.2060202@cogentembedded.com>
Date: Mon, 27 May 2013 14:19:03 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MIPS: cavium-octeon: cvmx-helper-board: print unknown
 board warning only once
References: <1369600543-21558-1-git-send-email-aaro.koskinen@iki.fi>
In-Reply-To: <1369600543-21558-1-git-send-email-aaro.koskinen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 27-05-2013 0:35, Aaro Koskinen wrote:

> When booting a new board for the first time, the console is flooded with
> "Unknown board" messages. This is not really helpful. Board type is not
> going to change after the boot, so it's sufficient to print the warning
> only once.

> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> ---
>   arch/mips/cavium-octeon/executive/cvmx-helper-board.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

> diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
> index 7c64977..e0451a0 100644
> --- a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
> +++ b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
[...]
> @@ -184,8 +186,7 @@ int cvmx_helper_board_get_mii_address(int ipd_port)
>   	}
>
>   	/* Some unknown board. Somebody forgot to update this function... */
> -	cvmx_dprintf
> -	    ("cvmx_helper_board_get_mii_address: Unknown board type %d\n",
> +	pr_warn_once("%s: Unknown board type %d\n", __func__,
>   	     cvmx_sysinfo_get()->board_type);

    Please align this line under the next char under (.

WVR, Sergei

