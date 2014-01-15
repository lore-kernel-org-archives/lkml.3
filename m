Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaAOSD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:03:28 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:33179 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaAOSDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:03:23 -0500
Date: Wed, 15 Jan 2014 19:03:13 +0100
From: Robert Richter <rric@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] perf, ibs: Fix waking up from S3 for AMD family 10h
Message-ID: <20140115180313.GA8360@rric.localhost>
References: <1389797849-5565-1-git-send-email-rric.net@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389797849-5565-1-git-send-email-rric.net@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.01.14 15:57:29, Robert Richter wrote:
> @@ -816,6 +817,18 @@ static int force_ibs_eilvt_setup(void)
>  	return ret;
>  }
>  
> +void ibs_eilvt_setup(void)

Grrr, this is not static. Could this be changed when the patch is
applied assuming the rest is ok? Otherwise I will send an update.

Thanks,

-Robert

+{
> +	/*
> +	 * Force LVT offset assignment for family 10h: The offsets are
> +	 * not assigned by the BIOS for this family, so the OS is
> +	 * responsible for doing it. If the OS assignment fails, fall
> +	 * back to BIOS settings and try to setup this.
> +	 */
> +	if (boot_cpu_data.x86 == 0x10)
> +		force_ibs_eilvt_setup();
> +}
