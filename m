Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3JKWrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:47:43 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47842 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752273Ab3JKWrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:47:42 -0400
Message-ID: <52588005.4030806@hurleysoftware.com>
Date: Fri, 11 Oct 2013 18:47:33 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: tty: incorrect test of echo_buf() result for ECHO_OP_START
References: <alpine.DEB.2.02.1310112126001.11060@Z>
In-Reply-To: <alpine.DEB.2.02.1310112126001.11060@Z>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 04:08 PM, Roel Kluin wrote:
> Untested, but this looks like a bug to me

Careless error on my part. Fix looks good; thanks for catching this.

Regards,
Peter Hurley

> -----------
> test echo_buf() result for ECHO_OP_START
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 7a744b6..42b6cca 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -767,7 +767,7 @@ static size_t __process_echoes(struct tty_struct *tty)
>   	 * of echo overrun before the next commit), then discard enough
>   	 * data at the tail to prevent a subsequent overrun */
>   	while (ldata->echo_commit - tail >= ECHO_DISCARD_WATERMARK) {
> -		if (echo_buf(ldata, tail == ECHO_OP_START)) {
> +		if (echo_buf(ldata, tail) == ECHO_OP_START) {
>   			if (echo_buf(ldata, tail) == ECHO_OP_ERASE_TAB)
>   				tail += 3;
>   			else

