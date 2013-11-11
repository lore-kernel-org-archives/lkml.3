Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3KKNmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:42:14 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:36160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab3KKNmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:42:06 -0500
Message-ID: <1384177312.14334.12.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCHv2] net: wireless: iwlwifi: remove minor dead code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 11 Nov 2013 14:41:52 +0100
In-Reply-To: <87iow080zv.fsf@mina86.com> (sfid-20131110_211839_411605_2F9FC912)
References: <1384110397-24386-1-git-send-email-mpn@google.com>
	 <527FDB50.1050902@cogentembedded.com> <87iow080zv.fsf@mina86.com>
	 (sfid-20131110_211839_411605_2F9FC912)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-10 at 21:17 +0100, Michal Nazarewicz wrote:
> inta is checked to be zero in a IRQ_NONE branch so afterwards it
> cannot be zero as it is never modified.

no signed-off-by


> @@ -1150,7 +1149,14 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
>  	 * or due to sporadic interrupts thrown from our NIC. */
>  	if (!inta) {
>  		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
> -		goto none;
> +		/* re-enable interrupts here since we don't have anything to
> +		 * service.  only Re-enable if disabled by irq and no
> +		 * schedules tasklet.
> +		 */
> +		if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
> +		    !trans_pcie->inta)
> +			iwl_enable_interrupts(trans);
> +		return IRQ_NONE;

I don't really think duplicating this is really an improvement?

johannes

