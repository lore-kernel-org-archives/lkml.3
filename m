Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaBKQxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:53:30 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47210 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750909AbaBKQx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:53:28 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18SXLqHqKWhapgHvegG5qSchUc1f6Mvlnk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 5DC945247A4
Date: Tue, 11 Feb 2014 11:53:14 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/8] ARM: mvebu: make use of
 of_find_matching_node_and_match
Message-ID: <20140211165314.GA8533@titan.lakedaemon.net>
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
 <1392135847-30791-5-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392135847-30791-5-git-send-email-joshc@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 10:24:02AM -0600, Josh Cartwright wrote:
> Instead of the of_find_matching_node()/of_match_node() pair, which requires two
> iterations through the match table, make use of of_find_matching_node_and_match(),
> which only iterates through the table once.
> 
> While we're here, mark the of_system_controller table const.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  arch/arm/mach-mvebu/system-controller.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-mvebu/system-controller.c b/arch/arm/mach-mvebu/system-controller.c
> index a7fb89a..e6e300a 100644
> --- a/arch/arm/mach-mvebu/system-controller.c
> +++ b/arch/arm/mach-mvebu/system-controller.c
> @@ -54,7 +54,7 @@ static const struct mvebu_system_controller orion_system_controller = {
>  	.system_soft_reset = 0x1,
>  };
>  
> -static struct of_device_id of_system_controller_table[] = {
> +static const struct of_device_id of_system_controller_table[] = {
>  	{
>  		.compatible = "marvell,orion-system-controller",
>  		.data = (void *) &orion_system_controller,
> @@ -90,13 +90,12 @@ void mvebu_restart(enum reboot_mode mode, const char *cmd)
>  
>  static int __init mvebu_system_controller_init(void)
>  {
> +	const struct of_device_id *match;
>  	struct device_node *np;
>  
> -	np = of_find_matching_node(NULL, of_system_controller_table);
> +	np = of_find_matching_node_and_match(NULL, of_system_controller_table,
> +					     &match);
>  	if (np) {
> -		const struct of_device_id *match =
> -		    of_match_node(of_system_controller_table, np);


> -		BUG_ON(!match);

Gregory, is it ok to remove this?  It was added with the original code
submission for mach-mvebu.  mvebu_restart() will handle this
gracefully...

>  		system_controller_base = of_iomap(np, 0);
>  		mvebu_sc = (struct mvebu_system_controller *)match->data;
>  		of_node_put(np);

thx,

Jason.
