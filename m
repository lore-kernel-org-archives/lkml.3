Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab3FTIRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:17:34 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9783 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab3FTIRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:17:31 -0400
X-Spam-Score: -100.8
Message-ID: <51C2BA68.8050301@asianux.com>
Date: Thu, 20 Jun 2013 16:16:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/itimer.c: for return value, using -EINVAL instead
 of -EFAULT
References: <51C29FBC.1090507@asianux.com> <alpine.DEB.2.02.1306200847300.4013@ionos.tec.linutronix.de> <51C2ACB8.6050701@asianux.com> <alpine.DEB.2.02.1306200936470.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306200936470.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 03:44 PM, Thomas Gleixner wrote:
> We could do that, but that makes no sense. If we can detect it before
> copy_to_user() we can return the exactly same return value which we
> would return via copy_to_user(). That avoids to take a trap and run
> through the fixup code

I don't think "that makes no sense".

In most cases, the 'value' will not be NULL, so it is better for
performance (save one compare instruction, at least).

Also, it will make the code simpler and clearer for readers.



Thanks.
-- 
Chen Gang

Asianux Corporation
