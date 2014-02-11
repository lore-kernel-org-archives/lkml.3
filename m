Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaBKRfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:35:04 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:50862 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751937AbaBKRfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:35:01 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19jqhWK+4+4O6kgXjrPLrZH6//KTPmd7qI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 012815249ED
Date: Tue, 11 Feb 2014 12:34:46 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Josh Cartwright <joshc@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 4/8] ARM: mvebu: make use of
 of_find_matching_node_and_match
Message-ID: <20140211173446.GC27395@titan.lakedaemon.net>
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
 <1392135847-30791-5-git-send-email-joshc@codeaurora.org>
 <20140211165314.GA8533@titan.lakedaemon.net>
 <20140211181048.6934bdd3@skate>
 <52FA5E75.7030402@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FA5E75.7030402@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 06:31:33PM +0100, Gregory CLEMENT wrote:
> On 11/02/2014 18:10, Thomas Petazzoni wrote:
> > Dear Jason Cooper,
> > 
> > On Tue, 11 Feb 2014 11:53:14 -0500, Jason Cooper wrote:
> > 
> >>> -	np = of_find_matching_node(NULL, of_system_controller_table);
> >>> +	np = of_find_matching_node_and_match(NULL, of_system_controller_table,
> >>> +					     &match);
> >>>  	if (np) {
> >>> -		const struct of_device_id *match =
> >>> -		    of_match_node(of_system_controller_table, np);
> >>
> >>
> >>> -		BUG_ON(!match);
> >>
> >> Gregory, is it ok to remove this?  It was added with the original code
> >> submission for mach-mvebu.  mvebu_restart() will handle this
> >> gracefully...
> > 
> > The BUG_ON here can normally never be reached. If
> > of_find_matching_node() returns a non-NULL result, then of_match_node()
> > should also return a non-NULL result.
> > 
> > Or I'm missing something :)
> 
> No you're almost right!
> 
> The only case we can get it, would be if we were declaring something like:
> 
> static struct of_device_id of_system_controller_table[] = {
> 	{
> 		.compatible = "foo,bar-controller",
> 	},
> [...]
> 
> instead of
> 
> static struct of_device_id of_system_controller_table[] = {
> 	{
> 		.compatible = "foo,bar",
> 		.data = (void *) &bar_controller,
> 	},
> [...]
> 
> This test is very paranoid, so I agree to remove it.
> 
> 
> Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Ok, great!  Josh, do you want us to take the two mvebu patches through
mvebu/arm-soc?  Or would you prefer to take them?

thx,

Jason.
