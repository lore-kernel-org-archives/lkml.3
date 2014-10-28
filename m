Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaJ1UKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:10:52 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56273 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaJ1UKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:10:51 -0400
Date: Tue, 28 Oct 2014 13:10:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: i8042 - add mux quirk for HP EliteBook 8470p
Message-ID: <20141028201046.GB7461@dtor-ws>
References: <1414525704-8409-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414525704-8409-1-git-send-email-luis.henriques@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On Tue, Oct 28, 2014 at 07:48:24PM +0000, Luis Henriques wrote:
> This laptop requires active multiplexing to be enabled in order to be able
> to separate the PS/2 mouse and the touchpad.
> 
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index a0bcbb64d06d..34b95e4268eb 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -220,6 +220,13 @@ static const struct dmi_system_id __initconst i8042_dmi_mux_table[] = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "CF-18"),
>  		},
>  	},
> +	{
> +		/* HP EliteBook 8470p */
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 8470p"),

Hmm, so the tide is turning the other way ;) I think I'll be comfortable
extending this to all EliteBooks as I know 840 and 1040 work as well and
I have not heard any other complaints about this model line.

Cold you resend with match on "HP EliteBook" instead of "HP EliteBook
8470p"?

Thanks.

-- 
Dmitry
