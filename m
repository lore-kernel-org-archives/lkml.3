Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaJPTar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:30:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40802 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752035AbaJPTaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:30:46 -0400
Message-ID: <54401CE3.8000307@free-electrons.com>
Date: Thu, 16 Oct 2014 21:30:43 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: hare@suse.de, JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] aic7xxx: replace kmalloc/memset by kzalloc
References: <1413486878-375-1-git-send-email-michael.opdenacker@free-electrons.com> <1413487720.15773.1.camel@perches.com>
In-Reply-To: <1413487720.15773.1.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 10/16/2014 09:28 PM, Joe Perches wrote:
> On Thu, 2014-10-16 at 21:14 +0200, Michael Opdenacker wrote:
>
>  
>  	/* Allocate SCB resources */
> -	scb_data->scbarray = kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
> +	scb_data->scbarray = kzalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC,
> +				GFP_ATOMIC);
>  	if (scb_data->scbarray == NULL)
>  		return (ENOMEM);
> -	memset(scb_data->scbarray, 0, sizeof(struct scb) * AHC_SCB_MAX_ALLOC);
>  
>  	/* Determine the number of hardware SCBs and initialize them */
>  
> Probably better as kcalloc.

Hey, well spotted! Thanks for your review. I will post a new version soon.

Cheers,

Michael.

>


-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

