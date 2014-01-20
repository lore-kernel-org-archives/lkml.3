Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaATQ3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:29:02 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:62465 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaATQ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:28:59 -0500
Message-ID: <52DD4EC6.7080208@gmail.com>
Date: Mon, 20 Jan 2014 17:28:54 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v2] socket.7: add description for SO_BUSY_POLL
References: <20130710141835.15799.61657.stgit@ladj378.jer.intel.com>
In-Reply-To: <20130710141835.15799.61657.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 04:18 PM, Eliezer Tamir wrote:
> Add description for the SO_BUSY_POLL socket option to the socket(7) manpage.

Long after the fact, I've applied this. Thanks, Eliezer.

Would you be willing also to write a patch for the POLL_BUSY_LOOP flag of 
poll()?

Cheers,

Michael


> v2
> fixed typos reported by Rasmus Villemoes
> 
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---
> 
>  man7/socket.7 |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/man7/socket.7 b/man7/socket.7
> index f2213eb..5edcb09 100644
> --- a/man7/socket.7
> +++ b/man7/socket.7
> @@ -694,6 +694,31 @@ for details on control messages.
>  Gets the socket type as an integer (e.g.,
>  .BR SOCK_STREAM ).
>  This socket option is read-only.
> +.TP
> +.B SO_BUSY_POLL
> +Sets the approximate time in microseconds to busy poll on a blocking receive
> +when there is no data. Increasing this value requires
> +.BR CAP_NET_ADMIN . 
> +The default for this option is controlled by the
> +.I /proc/sys/net/core/busy_read
> +file. 
> +
> +The value in the  
> +.I /proc/sys/net/core/busy_poll
> +file determines how long 
> +.BR select (2)
> +and 
> +.BR poll (2)
> +will busy poll when they operate on sockets with 
> +.BR SO_BUSY_POLL
> +set and no events to report are found.
> +
> +In both cases busy polling will only be done when the socket last received data
> +from a network device that supports this option.
> +
> +While busy polling may improve latency of some applications, care must be
> +taken when using it since this will increase both CPU utilization and power usage.
> +
>  .SS Signals
>  When writing onto a connection-oriented socket that has been shut down
>  (by the local or the remote end)
> 
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
