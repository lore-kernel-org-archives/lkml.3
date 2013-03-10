Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3CJQfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 12:35:45 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.41]:35548 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3CJQfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 12:35:44 -0400
Message-ID: <513CB587.5010304@ladisch.de>
Date: Sun, 10 Mar 2013 17:32:07 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Vicentiu Ciorbaru <cvicentiu@gmail.com>
CC: perex@perex.cz, tiwai@suse.de, wfp5p@virginia.edu,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] emu10k1: Fix coccicheck warning
References: <1362919067-17250-1-git-send-email-cvicentiu@gmail.com>
In-Reply-To: <1362919067-17250-1-git-send-email-cvicentiu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vicentiu Ciorbaru wrote:
> Removed redundant cast of kmalloc return pointer.

> -	    (icode->gpr_map = (u_int32_t __user *)
> -	     kcalloc(512 + 256 + 256 + 2 * 1024, sizeof(u_int32_t),
> -		     GFP_KERNEL)) == NULL ||
> +	    (icode->gpr_map = kcalloc(512 + 256 + 256 + 2 * 1024,
> +				sizeof(u_int32_t), GFP_KERNEL)) == NULL ||

Why would casting to __user be redundant?


Regards,
Clemens
