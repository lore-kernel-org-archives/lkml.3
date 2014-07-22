Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaGVOFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:05:19 -0400
Received: from canardo.mork.no ([148.122.252.1]:37513 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbaGVOFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:05:17 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: dougthompson@xmission.com, bp@alien8.de, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac: Remove fixmes in e7xxx_edac.c
Organization: m
References: <1406004789-9918-1-git-send-email-xerofoify@gmail.com>
Date: Tue, 22 Jul 2014 16:04:41 +0200
In-Reply-To: <1406004789-9918-1-git-send-email-xerofoify@gmail.com> (Nicholas
	Krause's message of "Tue, 22 Jul 2014 00:53:09 -0400")
Message-ID: <874my98p6u.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Krause <xerofoify@gmail.com> writes:

> This removes two Page shift fixs me in this file and not checking
> if row is -1 in process_ce as it cannot be this value or be must
> exit this function by returning.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/edac/e7xxx_edac.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
> index 3cda79b..563983f 100644
> --- a/drivers/edac/e7xxx_edac.c
> +++ b/drivers/edac/e7xxx_edac.c
> @@ -211,12 +211,13 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
>  	edac_dbg(3, "\n");
>  	/* read the error address */
>  	error_1b = info->dram_celog_add;
> -	/* FIXME - should use PAGE_SHIFT */
> -	page = error_1b >> 6;	/* convert the address to 4k page */
> +	page = error_1b >> PAGE_SHIFT;	/* convert the address to 4k page */

I just have to bite...  Where did you get the idea that you can go
around and "fix" FIMXE's like they were spelling errors?


Bjørn
