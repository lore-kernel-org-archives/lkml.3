Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbbAPPDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:03:45 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:54339 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbbAPPDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:03:44 -0500
Message-ID: <1421420621.8562.1.camel@x220>
Subject: Re: [PATCH] mm/page_owner: Fix memory leak
From: Paul Bolle <pebolle@tiscali.nl>
To: Valentin Ilie <valentin.ilie@gmail.com>
Cc: iamjoonsoo.kim@lge.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Jan 2015 16:03:41 +0100
In-Reply-To: <1421410284-23776-1-git-send-email-valentin.ilie@gmail.com>
References: <1421410284-23776-1-git-send-email-valentin.ilie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2015 15:03:42.0423 (UTC) FILETIME=[9E00E670:01D0319D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-16 at 14:11 +0200, Valentin Ilie wrote:
> Call kfree on list2 after using it.
> 
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
> ---
>  tools/vm/page_owner_sort.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/vm/page_owner_sort.c b/tools/vm/page_owner_sort.c
> index 77147b4..92292d5 100644
> --- a/tools/vm/page_owner_sort.c
> +++ b/tools/vm/page_owner_sort.c
> @@ -139,6 +139,8 @@ int main(int argc, char **argv)
>  
>  	for (i = 0; i < count; i++)
>  		fprintf(fout, "%d times:\n%s\n", list2[i].num, list2[i].txt);
> +	

Checkpatch would have caught the tab you added here.

> +	kfree(list2);

You didn't even compile this, did you?
 
>  	return 0;
>  }

Thanks,


Paul Bolle

