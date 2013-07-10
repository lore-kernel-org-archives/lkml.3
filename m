Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3GJSoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:44:20 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52516 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab3GJSoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:44:13 -0400
Message-ID: <51DDA1DC.2020306@gmail.com>
Date: Wed, 10 Jul 2013 20:03:08 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: Micahel Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org,
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

On 07/10/13 16:18, Eliezer Tamir wrote:
> Add description for the SO_BUSY_POLL socket option to the socket(7) manpage.
> 
> v2
> fixed typos reported by Rasmus Villemoes

Eliezer,

What's the status of this feature. A quick grep seems to show
that the feature is not yet in mainline. What is the plan?

Thanks,

Michael



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

