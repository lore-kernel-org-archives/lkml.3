Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaJAVbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:31:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36987 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaJAVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:31:51 -0400
Date: Fri, 12 Sep 2014 16:40:31 +0200
From: Pavel Machek <pavel@denx.de>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: sre@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HSI: remove deprecated IRQF_DISABLED
Message-ID: <20140912143722.GA22420@xo-6d-61-c0.localdomain>
References: <1412195335-9437-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412195335-9437-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-10-01 22:28:55, Michael Opdenacker wrote:
> Remove the use of the IRQF_DISABLED flag
> from drivers/hsi/clients/nokia-modem.c
> 
> It's a NOOP since 2.6.35 and it will be removed soon.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Acked-by: Pavel Machek <pavel@ucw.cz>



> --- a/drivers/hsi/clients/nokia-modem.c
> +++ b/drivers/hsi/clients/nokia-modem.c
> @@ -174,7 +174,7 @@ static int nokia_modem_probe(struct device *dev)
>  	tasklet_init(&modem->nokia_modem_rst_ind_tasklet,
>  			do_nokia_modem_rst_ind_tasklet, (unsigned long)modem);
>  	err = devm_request_irq(dev, irq, nokia_modem_rst_ind_isr,
> -				IRQF_DISABLED | pflags, "modem_rst_ind", modem);
> +				pflags, "modem_rst_ind", modem);
>  	if (err < 0) {
>  		dev_err(dev, "Request rst_ind irq(%d) failed (flags %d)\n",
>  								irq, pflags);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
