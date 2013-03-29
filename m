Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3C2NvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:51:11 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:54094 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3C2NvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:51:10 -0400
Message-ID: <51559C4A.7060905@acm.org>
Date: Fri, 29 Mar 2013 08:51:06 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        openipmi-developer@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/char/ipmi: memcpy, need additional 2 bytes to
 avoid memory overflow
References: <51554055.90500@asianux.com>
In-Reply-To: <51554055.90500@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, this is correct, I've pulled it into my tree.

-corey

On 03/29/2013 02:18 AM, Chen Gang wrote:
>    when calling memcpy, read_data and write_data need additional 2 bytes.
>
>    write_data:
>      for checking:  "if (size > IPMI_MAX_MSG_LENGTH)"
>      for operating: "memcpy(bt->write_data + 3, data + 1, size - 1)"
>
>    read_data:
>      for checking:  "if (msg_len < 3 || msg_len > IPMI_MAX_MSG_LENGTH)"
>      for operating: "memcpy(data + 2, bt->read_data + 4, msg_len - 2)"
>
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>   drivers/char/ipmi/ipmi_bt_sm.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
> index cdd4c09f..a22a7a5 100644
> --- a/drivers/char/ipmi/ipmi_bt_sm.c
> +++ b/drivers/char/ipmi/ipmi_bt_sm.c
> @@ -95,9 +95,9 @@ struct si_sm_data {
>   	enum bt_states	state;
>   	unsigned char	seq;		/* BT sequence number */
>   	struct si_sm_io	*io;
> -	unsigned char	write_data[IPMI_MAX_MSG_LENGTH];
> +	unsigned char	write_data[IPMI_MAX_MSG_LENGTH + 2]; /* +2 for memcpy */
>   	int		write_count;
> -	unsigned char	read_data[IPMI_MAX_MSG_LENGTH];
> +	unsigned char	read_data[IPMI_MAX_MSG_LENGTH + 2]; /* +2 for memcpy */
>   	int		read_count;
>   	int		truncated;
>   	long		timeout;	/* microseconds countdown */

