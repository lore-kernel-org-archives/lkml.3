Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3GHJ4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:56:10 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:52372 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751134Ab3GHJ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:56:08 -0400
Message-ID: <51DA8CB6.2010109@itdev.co.uk>
Date: Mon, 08 Jul 2013 10:56:06 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 22/51] Input: atmel_mxt_ts - Add shutdown function
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk> <1372337366-9286-23-git-send-email-nick.dyer@itdev.co.uk> <20130707052934.GB15453@core.coreip.homeip.net>
In-Reply-To: <20130707052934.GB15453@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Thu, Jun 27, 2013 at 01:48:57PM +0100, Nick Dyer wrote:
>> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
>> Acked-by: Benson Leung <bleung@chromium.org>
> 
> Why is this needed?

The patch disables the interrupt handler on shutdown.

One of our customers reported a bug caused by input events being generated
during shutdown (for example if the user was touching the device whilst it
was turning off), which was solved by putting in this change.

However, now you've drawn my attention to it again, it seems to me that
probably a better thing for us to be doing would be to power off the
touchscreen controller here, and let the interrupt disable be handled by
core code - do you agree?
