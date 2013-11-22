Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3KVWU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:20:58 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33543 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261Ab3KVWUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:20:52 -0500
Date: Fri, 22 Nov 2013 14:20:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 1/5] tty: Always handle NULL flag ptr
Message-ID: <20131122222040.GA12800@core.coreip.homeip.net>
References: <1385140198-5822-1-git-send-email-peter@hurleysoftware.com>
 <1385140198-5822-2-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385140198-5822-2-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Nov 22, 2013 at 12:09:54PM -0500, Peter Hurley wrote:
> Most line disciplines already handle the undocumented NULL flag
> ptr in their .receive_buf method; however, several don't.
> 
> Document the NULL flag ptr, and correct handling in the
> N_MOUSE, N_GSM0710 and N_R394 line disciplines.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/input/serio/serport.c | 28 +++++++++++++++-------------
>  drivers/tty/n_gsm.c           |  5 +++--
>  drivers/tty/n_r3964.c         |  2 +-
>  include/linux/tty_ldisc.h     |  6 ++++--
>  4 files changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
> index 8755f5f..72b4633 100644
> --- a/drivers/input/serio/serport.c
> +++ b/drivers/input/serio/serport.c
> @@ -124,7 +124,7 @@ static void serport_ldisc_receive(struct tty_struct *tty, const unsigned char *c
>  {
>  	struct serport *serport = (struct serport*) tty->disc_data;
>  	unsigned long flags;
> -	unsigned int ch_flags;
> +	unsigned int ch_flags = TTY_NORMAL;

We should not be passing tty constants into serio layer as they are
different subsystems (even though TTY_NORMAL happens to be encoded as 0
and thus happens to work). Please use 0 for 'no flags' as the original
code did.

Other than that the serio portion looks good to me.

Thanks.

-- 
Dmitry
