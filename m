Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab3HOPws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 11:52:48 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:9297 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757460Ab3HOPwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 11:52:46 -0400
Message-ID: <520CF94B.7030006@itdev.co.uk>
Date: Thu, 15 Aug 2013 16:52:43 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: rydberg@euromail.se
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 45/51] Input: atmel_mxt_ts - Release touch state during
 suspend
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk> <1372337366-9286-46-git-send-email-nick.dyer@itdev.co.uk> <20130718172953.GI32381@polaris.bitmath.org>
In-Reply-To: <20130718172953.GI32381@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rydberg@euromail.se wrote:
> On Thu, Jun 27, 2013 at 01:49:20PM +0100, Nick Dyer wrote:
>> If fingers are down as the MXT chip goes into suspend it does not send a lift
>> message. In addition, it may not complete its final measurement cycle
>> immediately, which means touch messages may be received by the interrupt
>> handler after mxt_stop() has completed.
> 
> How long is the window of possible stray interrupts? Could this be
> done with a small delay instead of keeping track of the suspend state?

The touch controller has its own acquisition scheduling which switches
between active/idle modes. Which mode it is in isn't explicitly
communicated to the driver.

If we could tell it was in active mode (which would involve some hairier
code than this patch involves), we might have to wait ~20ms on a modern
device. But the worst case is that we would have to wait for the idle scan
interval plus some margin, so a couple of hundred ms. I think that is too
long, right?
