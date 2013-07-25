Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab3GYPMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:12:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:59565 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3GYPMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:12:15 -0400
Message-ID: <51F1404B.7070207@linutronix.de>
Date: Thu, 25 Jul 2013 17:12:11 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 15/16] dmaengine: add transfered member to dma_async_tx_descriptor
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-16-git-send-email-bigeasy@linutronix.de> <51F13CEB.7030408@metafoo.de>
In-Reply-To: <51F13CEB.7030408@metafoo.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 04:57 PM, Lars-Peter Clausen wrote:
> I'm not sure that this will work. Once you've submitted the descriptor it is
> owned by the dmaengine driver and you are not allowed to dereference it
> anymore since the dmaengine driver might free the memory at any time. You
> should only reference the descriptor by the cookie returned by submit().

I see. But it can't be reused before calling the callback if it is
going to call the callback, right?
So if this is a no-no, I'm left with an additional argument to the
complete callback?

> - Lars

Sebastian
