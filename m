Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaBOTEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:04:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbaBOTEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:04:07 -0500
Date: Sat, 15 Feb 2014 11:05:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: linux-kernel@vger.kernel.org, s-anna@ti.com, tony@atomide.com,
        omar.ramirez@copitl.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        rafael.j.wysocki@intel.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
Message-ID: <20140215190528.GC1801@kroah.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
 <1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 11:55:27PM +0530, Jassi Brar wrote:
> +/*
> + * After 'startup' and before 'shutdown', the IPC controller driver
> + * notifies the API of data received over the link.
> + * The controller driver should make sure the 'RTR' is de-asserted since
> + * reception of the packet and until after this call returns.
> + * This call could be made from atomic context.
> + */
> +void ipc_link_received_data(struct ipc_link *link, void *mssg)
> +{
> +	struct ipc_chan *chan = (struct ipc_chan *)link->api_priv;
> +
> +	/* No buffering the received data */
> +	if (chan->rxcb)
> +		chan->rxcb(chan->cl_id, mssg);
> +}
> +EXPORT_SYMBOL(ipc_link_received_data);

EXPORT_SYMBOL_GPL() on all of these perhaps?

