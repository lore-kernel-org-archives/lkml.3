Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3HCXPQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 19:15:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29247 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3HCXPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 19:15:14 -0400
Date: Sun, 4 Aug 2013 02:14:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Frederich <jfrederich@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, cjb@laptop.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: Re: [PATCH] Staging: olpc_dcon: replace some magic numbers
Message-ID: <20130803231447.GF5051@mwanda>
References: <1375562675-7816-1-git-send-email-jfrederich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375562675-7816-1-git-send-email-jfrederich@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 03, 2013 at 10:44:35PM +0200, Jens Frederich wrote:
> @@ -126,7 +127,7 @@ static int dcon_bus_stabilize(struct dcon_priv *dcon, int is_powered_down)
>  power_up:
>  	if (is_powered_down) {
>  		x = 1;
> -		x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
> +		x = olpc_ec_cmd(EC_DCON_POWER_MODE, (u8 *)&x, 1, NULL, 0);
                                                    ^^^^^^^^
You didn't introduce this but using "x" as the inbuf here messy.
It should be char instead of an int.  The code won't work on big
endian systems.  I know this hardware is only available on little
endian systems and that's why it's not a bug.  It's just an ugly
thing to do.

(Since you didn't introduce this, it means your patch is fine and
you can ignore this email.  I am just commenting in case anyone
wants to fix clean it up).

>  		if (x) {
>  			pr_warn("unable to force dcon to power up: %d!\n", x);
>  			return x;

regards,
dan carpenter
