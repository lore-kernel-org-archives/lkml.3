Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaKKMZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:25:37 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaKKMZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:25:35 -0500
Message-ID: <5462003C.9090509@nod.at>
Date: Tue, 11 Nov 2014 13:25:32 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Tanya Brokhman <tlinder@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org>	 <5460F7D8.2030100@nod.at> <5461C5AD.5040705@nod.at> <1415707434.22887.158.camel@sauron.fi.intel.com>
In-Reply-To: <1415707434.22887.158.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.11.2014 um 13:03 schrieb Artem Bityutskiy:
> On Tue, 2014-11-11 at 09:15 +0100, Richard Weinberger wrote:
>>> Do we really want the function name in every log message?
>>> IMHO this is not wise except for pure debug logs.
>>
>> BTW: Why UBI-X? This looks odd. Either use UBIX or ubiX.
> 
> How about something like this (untested):
> 
> 
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> Date: Tue, 11 Nov 2014 13:56:34 +0200
> Subject: [PATCH] UBI: clean-up printing helpers
> 
> Let's prefix UBI messages with 'ubiX' instead of 'UBI-X' - this is more
> consistent with the way we name UBI devices.
> 
> Also, commit "32608703 UBI: Extend UBI layer debug/messaging capabilities"
> added the function name print to 'ubi_msg()' - lets revert this change, since
> these messages are supposed to be just informative messages, and not debugging
> messages.

What is the benefit of having the function name still in ubi_warn() and ubi_err()?
e.g.
[   95.511825] ubi0 error: ubi_attach_mtd_dev: mtd0 is already attached to ubi0

If the log message is so cryptic that you need to lookup it in the source to understand it,
we better fix the message.

> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
>  drivers/mtd/ubi/ubi.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
> index f80ffab..7a92283 100644
> --- a/drivers/mtd/ubi/ubi.h
> +++ b/drivers/mtd/ubi/ubi.h
> @@ -50,13 +50,13 @@
>  #define UBI_NAME_STR "ubi"
>  
>  /* Normal UBI messages */
> -#define ubi_msg(ubi, fmt, ...) pr_notice("UBI-%d: %s:" fmt "\n", \
> -					 ubi->ubi_num, __func__, ##__VA_ARGS__)
> +#define ubi_msg(ubi, fmt, ...) pr_notice("ubi%d: " fmt "\n", \
> +					 ubi->ubi_num, ##__VA_ARGS__)

We could even use UBI_NAME_STR here. :-)

Thanks,
//richard
