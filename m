Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaJTWUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:20:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33063 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaJTWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:20:05 -0400
Date: Mon, 20 Oct 2014 15:20:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Kumar Gala <galak@codeaurora.org>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] tty: serial: msm: Fix lock init issue with earlycon
Message-ID: <20141020222003.GD12469@codeaurora.org>
References: <1413551588-14877-1-git-send-email-galak@codeaurora.org>
 <544553F6.1020409@codeaurora.org>
 <544580ED.3050604@hurleysoftware.com>
 <20141020221656.GC12469@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020221656.GC12469@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20, Stephen Boyd wrote:
> On 10/20, Peter Hurley wrote:
> > 
> > FWIW, __msm_console_write() is a deadlock-waiting-to_happen since it does
> > not disable interrupts with spin_lock_irqsave().
> > 
> 
> Yeah we should fix that. As far as I can tell we've never used
> the irqsave variant of the lock in the console path. Did this
> become necessary at some point since this driver was introduced?
> I'm wondering how many stable trees need the fix.

Actually I don't see this case. It looks like the console is
always called in call_console_drivers() with irqs saved and
disabled via the logbuf_lock in console_cont_flush() or
console_unlock().

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
