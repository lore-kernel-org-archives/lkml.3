Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3KGNuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:50:01 -0500
Received: from www.linutronix.de ([62.245.132.108]:51769 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3KGNt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:49:58 -0500
Message-ID: <527B9A7F.8000006@linutronix.de>
Date: Thu, 07 Nov 2013 14:49:51 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: balbi@ti.com, stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: f_mass_storage: call try_to_freeze only
 when its safe
References: <1383831439-25558-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1383831439-25558-1-git-send-email-george.cherian@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 02:37 PM, George Cherian wrote:
> Call try_to_freeze() in sleep_thread() only when its safe to sleep.
> do_read() and do_write() calls sleep_thread with lock held.
> Make sure these wont call try_to_freeze() by passing can_freeze flag
> to sleep_thread.

Thank you. This is was Alan asked for and I forgot.

You could add

|Calling try_to_freeze() with a lock hold was done since day one in
|f_mass_storage but since commit 0f9548ca1 ("lockdep: check that no
|locks held at freeze time") lockdep complains about it.

so we have an explanation why it is suddenly a bad thing.

> Signed-off-by: George Cherian <george.cherian@ti.com>

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
