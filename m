Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaETDrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 23:47:47 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33440 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaETDrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 23:47:46 -0400
Date: Mon, 19 May 2014 20:47:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] input: cyapa: rearchitecture driver to support
 function pointers
Message-ID: <20140520034742.GC986@core.coreip.homeip.net>
References: <77BC725C9062764F874D79F51E1F1A8F40C1405E@S04-MBX01-01.s04.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77BC725C9062764F874D79F51E1F1A8F40C1405E@S04-MBX01-01.s04.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dudley,

On Wed, Apr 16, 2014 at 08:35:52AM +0000, Dudley Du wrote:
> Re-architecture the driver to support function pointers, so it can support and integrate new devices later in one driver.
> Including use async thread in device proble to speed up system boot time.
> TEST=test on Chomebooks.

There seems to be changes implementing aasync probing intermixed with
the function pointers change, it had to be split out and justification
needs to be provided - I am not quite convinced we should be doing this,
at least not at individual driver level.

Also instead of listing individual function pointers consider defining

struct cyapa_ops {
	void (*irq_handler)(struct cyapa *);
	int (*set_power_mode)(struct cyapa *, u8, u16);
	int (*bl_enter_func)(struct cyapa *);
	....
};

and use const pointer to it in cyapa_state. Then you can have gen3 and
gen5 implementation separated into individual files and the rest forming
cyapa core.

Thanks.

-- 
Dmitry
