Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3IMSnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:43:19 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:39868 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab3IMSnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:43:16 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5knFuK6YxiM=
X-RZG-CLASS-ID: mo00
Message-ID: <52335CC0.9070400@hartkopp.net>
Date: Fri, 13 Sep 2013 20:43:12 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130820 Icedove/17.0.8
MIME-Version: 1.0
To: Andre Naujoks <nautsch2@gmail.com>
CC: davem@davemloft.net, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 3/3] slcan: rewrite of slc_bump and slc_encaps
References: <1379093833-4949-1-git-send-email-nautsch2@gmail.com> <1379093833-4949-4-git-send-email-nautsch2@gmail.com>
In-Reply-To: <1379093833-4949-4-git-send-email-nautsch2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.09.2013 19:37, Andre Naujoks wrote:
> The old implementation was heavy on str* functions and sprintf calls.
> This version is more manual, but faster.
> 
> Profiling just the printing of a 3 char CAN-id resulted in 60 instructions
> for the manual method and over 2000 for the sprintf method. Bear in
> mind the profiling was done against libc and not the kernel sprintf.
> 
> Together with this rewrite an issue with sending and receiving of RTR frames
> has been fixed by Oliver for the cases that the DLC is not zero.
> 
> Signed-off-by: Andre Naujoks <nautsch2@gmail.com>
> Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
> ---
>  drivers/net/can/slcan.c | 136 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 87 insertions(+), 49 deletions(-)

As the layout of the generated content is fixed the provided flexibility of
the used string functions was indeed inadequate.

Thanks for the effort, Andre.

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>


