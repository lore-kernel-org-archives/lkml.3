Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbaBACgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 21:36:14 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41558 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932462AbaBACgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 21:36:13 -0500
Date: Fri, 31 Jan 2014 21:36:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Zoran Markovic <zoran.markovic@linaro.org>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Julius Werner <jwerner@chromium.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Matthias Beyer <mail@beyermatthias.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>
Subject: Re: [RFC PATCH] usb: move hub init and LED blink work to power
 efficient workqueue
In-Reply-To: <1391207948-17063-1-git-send-email-zoran.markovic@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1401312133190.20185-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014, Zoran Markovic wrote:

> From: Shaibal Dutta <shaibal.dutta@broadcom.com>
> 
> Allow the scheduler to select the best CPU to handle hub initalization
> and LED blinking work. This extends idle residency times on idle CPUs
> and conserves power.
> 
> This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

...

> @@ -1046,8 +1047,9 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
>  		if (type == HUB_INIT) {
>  			delay = hub_power_on(hub, false);
>  			PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func2);
> -			schedule_delayed_work(&hub->init_work,
> -					msecs_to_jiffies(delay));
> +			queue_delayed_work(system_power_efficient_wq,
> +					   &hub->init_work,
> +					   msecs_to_jiffies(delay));

I have no objection to selecting the power-efficient work queue, but
please don't change the indentation of the existing code.  The style
used throughout (most of) the USB core is that continuation lines are
indented by two tab stops more than the first line of the statement.

Alan Stern

