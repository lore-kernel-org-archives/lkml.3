Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510AbaLKXL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:11:29 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:39099 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934114AbaLKXL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:11:27 -0500
Date: Thu, 11 Dec 2014 23:11:00 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        NeilBrown <neil@brown.name>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] TTY/slave: add driver for w2sg0004 GPS
Message-ID: <20141211231100.05782a30@lxorguk.ukuu.org.uk>
In-Reply-To: <20141211215944.4127.57146.stgit@notabene.brown>
References: <20141211214801.4127.93914.stgit@notabene.brown>
	<20141211215944.4127.57146.stgit@notabene.brown>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +w2sg0004 UART-attached GPS receiver
> +

I'm wondering why it's tied to the w2sg0004


> +struct w2sg_data {
> +	int		gpio;
> +	int		irq;	/* irq line from RX pin when pinctrl
> +				 * set to 'idle' */
> +	struct regulator *reg;
> +
> +	unsigned long	last_toggle;	/* jiffies when last toggle completed. */
> +	unsigned long	backoff;	/* jiffies since last_toggle when
> +					 * we try again
> +					 */
> +	enum {Idle, Down, Up} state;	/* state-machine state. */
> +	bool		requested, is_on;
> +	bool		suspended;
> +	bool		reg_enabled;
> +
> +	struct delayed_work work;
> +	spinlock_t	lock;
> +	struct device	*dev;
> +
> +	struct rfkill	*rfkill;

So its
- a regulator (optional)
- an irq (optional)
- a gpio  (could be optional)
- an optional rfkill
- a pulse time (10ms fixed)
- a backoff time (1 second fixed)


It looks identical to half a dozen other widgets that are found in
Android phones. Would it perhaps be better to make the tiny tweaks to
make it generic

- make the timers configurable
- make the pulse time or high/low selectable for on/off
- make the gpio optional

and just have one driver with the right DT for all similar devices?

Am I missing some w2sg004 specific bits here ?


I think the general model is right, and there will be other slaves that
don't fit the pattern but I do think this one could be generalised.

Alan

