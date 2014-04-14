Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaDNQTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:19:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47649 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbaDNQTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:19:15 -0400
Message-ID: <534C0A74.6030305@zytor.com>
Date: Mon, 14 Apr 2014 09:19:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com
CC: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, MCE: Cleanup macro __get_cpu_var
References: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org> <1397464777-25451-1-git-send-email-gong.chen@linux.intel.com> <1397464777-25451-2-git-send-email-gong.chen@linux.intel.com>
In-Reply-To: <1397464777-25451-2-git-send-email-gong.chen@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 01:39 AM, Chen, Gong wrote:
> @@ -619,7 +619,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>  			continue;
>  
>  		v = &get_cpu_var(mce_polled_error);
> -		set_bit(0, v);
> +		*v = 1;
>  		put_cpu_var(mce_polled_error);
>  		/*
>  		 * Uncorrected or signalled events are handled by the exception

The amazing thing is that you managed to miss the one place where you
could actively elide a pointer.

The above should simply be:

	this_cpu_write(mce_polled_error, 1);

	-hpa

