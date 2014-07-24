Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbaGXQo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:44:56 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:54800 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759394AbaGXQoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:44:55 -0400
Message-ID: <1406220292.12720.2.camel@x41>
Subject: Re: [PATCH 2/3] staging: dgnc: Fix do not initialise statics to 0
 or NULL
From: Paul Bolle <pebolle@tiscali.nl>
To: Seunghun Lee <waydi1@gmail.com>
Cc: gregkh@linuxfoundation.org, lidza.louina@gmail.com, markh@compro.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 24 Jul 2014 18:44:52 +0200
In-Reply-To: <1406215613-9314-2-git-send-email-waydi1@gmail.com>
References: <1406215613-9314-1-git-send-email-waydi1@gmail.com>
	 <1406215613-9314-2-git-send-email-waydi1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2014 16:44:53.0814 (UTC) FILETIME=[9821A560:01CFA75E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seunghun Lee schreef op vr 25-07-2014 om 00:26 [+0900]:
> This patch fixes checkpatch errors
> "do not initialise statics to 0 or NULL"
> 
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> ---
>  drivers/staging/dgnc/dgnc_trace.c |    2 +-
>  drivers/staging/dgnc/dgnc_tty.c   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/dgnc/dgnc_trace.c b/drivers/staging/dgnc/dgnc_trace.c
> index 2f62f2a..9be4715 100644
> --- a/drivers/staging/dgnc/dgnc_trace.c
> +++ b/drivers/staging/dgnc/dgnc_trace.c
> @@ -43,7 +43,7 @@
>  static char *dgnc_trcbuf;		/* the ringbuffer */
>  
>  #if defined(TRC_TO_KMEM)
> -static int dgnc_trcbufi = 0;		/* index of the tilde at the end of */
> +static int dgnc_trcbufi;		/* index of the tilde at the end of */
>  #endif

I don't think TRC_TO_KMEM is defined anywhere. If that's correct, the
proper, well, fix for this checkpatch warning would be to remove all
code currently hidden behind the tests for that macro.

>  #if defined(TRC_TO_KMEM)


Paul Bolle

