Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab3BSQ5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:57:12 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36738 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932600Ab3BSQ5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:57:10 -0500
Message-ID: <1361293029.2360.4.camel@joe-AO722>
Subject: Re: [PATCHv2 1/1] block: IBM RamSan 70/80 driver fixes.
From: Joe Perches <joe@perches.com>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        josh.h.morris@us.ibm.com
Date: Tue, 19 Feb 2013 08:57:09 -0800
In-Reply-To: <20130219164811.GA21104@oc6784271780.ibm.com>
References: <20130219164811.GA21104@oc6784271780.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 10:48 -0600, Philip J. Kelleher wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> 
> This patch include a few driver fixes for the IBM RamSan 70/80 driver.

trivial comments:

> diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/config.c linux-block/drivers/block/rsxx/config.c
[]
> @@ -161,6 +161,17 @@ irqreturn_t rsxx_isr(int irq, void *pdat
>  }
>  
>  /*----------------- Card Event Handler -------------------*/
> +static char *rsxx_card_state_to_str(unsigned int state)

static const char *

> +{
> +	static char *state_strings[] = {

static const char * const state_strings[] = {

> +		"Unknown", "Shutdown", "Starting", "Formatting",
> +		"Uninitialized", "Good", "Shutting Down",
> +		"Fault", "Read Only Fault", "dStroying"
> +	};

[]

> @@ -390,8 +391,13 @@ static int __issue_creg_rw(struct rsxx_c
>  	if (st)
>  		return st;
>  
> +	/*
> +	 * This timeout is neccessary for unresponsive hardware. The additional

One "c" in necessary

> +	 * 20 seconds to used to guarantee that each cregs requests has time to
> +	 * complete.
> +	 */
>  	timeout = msecs_to_jiffies((CREG_TIMEOUT_MSEC *
> -				    card->creg_ctrl.q_depth) + 20000);
> +				card->creg_ctrl.q_depth) + 20000);

The alignment was nicer before this change.
Still using unnecessary parentheses.


