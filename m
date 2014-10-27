Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaJ0ORb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:17:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbaJ0ORa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:17:30 -0400
Date: Mon, 27 Oct 2014 15:17:28 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 09/11] tty: ipwireless: Fix probable mask then right
 shift defects
In-Reply-To: <5f61fec0dbc7d50715800c94b19db5914b1af610.1414387334.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1410271356050.20256@pobox.suse.cz>
References: <cover.1414387334.git.joe@perches.com> <5f61fec0dbc7d50715800c94b19db5914b1af610.1414387334.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2014, Joe Perches wrote:

> Precedence of & and >> is not the same and is not left to right.
> shift has higher precedence and should be done after the mask.
> 
> Add parentheses around the masks.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Jiri Kosina <jkosina@suse.cz>

Greg, can you take this through your char/misc tree, please?

Thanks.

> ---
>  drivers/tty/ipwireless/hardware.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/tty/ipwireless/hardware.c b/drivers/tty/ipwireless/hardware.c
> index 2c14842..5c77e1e 100644
> --- a/drivers/tty/ipwireless/hardware.c
> +++ b/drivers/tty/ipwireless/hardware.c
> @@ -378,9 +378,9 @@ static void swap_packet_bitfield_to_le(unsigned char *data)
>  	/*
>  	 * transform bits from aa.bbb.ccc to ccc.bbb.aa
>  	 */
> -	ret |= tmp & 0xc0 >> 6;
> -	ret |= tmp & 0x38 >> 1;
> -	ret |= tmp & 0x07 << 5;
> +	ret |= (tmp & 0xc0) >> 6;
> +	ret |= (tmp & 0x38) >> 1;
> +	ret |= (tmp & 0x07) << 5;
>  	*data = ret & 0xff;
>  #endif
>  }
> @@ -393,9 +393,9 @@ static void swap_packet_bitfield_from_le(unsigned char *data)
>  	/*
>  	 * transform bits from ccc.bbb.aa to aa.bbb.ccc
>  	 */
> -	ret |= tmp & 0xe0 >> 5;
> -	ret |= tmp & 0x1c << 1;
> -	ret |= tmp & 0x03 << 6;
> +	ret |= (tmp & 0xe0) >> 5;
> +	ret |= (tmp & 0x1c) << 1;
> +	ret |= (tmp & 0x03) << 6;
>  	*data = ret & 0xff;
>  #endif
>  }
> -- 
> 2.1.2
> 

-- 
Jiri Kosina
SUSE Labs
