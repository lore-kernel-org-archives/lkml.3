Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3KKNmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:42:54 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:36167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3KKNmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:42:46 -0500
Message-ID: <1384177358.14334.13.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCHv2] net: wireless: iwlwifi: remove minor dead code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 11 Nov 2013 14:42:38 +0100
In-Reply-To: <1384177312.14334.12.camel@jlt4.sipsolutions.net> (sfid-20131111_144211_754203_F365C56C)
References: <1384110397-24386-1-git-send-email-mpn@google.com>
	 <527FDB50.1050902@cogentembedded.com> <87iow080zv.fsf@mina86.com>
	 (sfid-20131110_211839_411605_2F9FC912) <1384177312.14334.12.camel@jlt4.sipsolutions.net>
	 (sfid-20131111_144211_754203_F365C56C)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-11 at 14:41 +0100, Johannes Berg wrote:
> > @@ -1150,7 +1149,14 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
> >  	 * or due to sporadic interrupts thrown from our NIC. */
> >  	if (!inta) {
> >  		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
> > -		goto none;
> > +		/* re-enable interrupts here since we don't have anything to
> > +		 * service.  only Re-enable if disabled by irq and no
> > +		 * schedules tasklet.
> > +		 */
> > +		if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
> > +		    !trans_pcie->inta)
> > +			iwl_enable_interrupts(trans);
> > +		return IRQ_NONE;
> 
> I don't really think duplicating this is really an improvement?

Err, sorry, not paying attention.

johannes

