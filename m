Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaFWIFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:05:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaFWIFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:05:19 -0400
Message-ID: <1403506697.10017.3.camel@linux-fkkt.site>
Subject: Re: [PATCH 2/2] drivers/net/usb/asix_devices.c: inline
 ax88772_unbind
From: Oliver Neukum <oneukum@suse.de>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Emil Goode <emilgoode@gmail.com>, linux-usb@vger.kernel.org
In-Reply-To: <1403296852-6376-1-git-send-email-fabf@skynet.be>
References: <1403296852-6376-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Jun 2014 08:58:17 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-20 at 22:40 +0200, Fabian Frederick wrote:
> inline this one line function used in driver_info structure

That precisely is this the reason not to inline this.
It is used as a function pointer. gcc must generate
a non-inlined version of the function.

Your patch has zero effect and suggests something that is
actually wrong.

	Regards
		Oliver


