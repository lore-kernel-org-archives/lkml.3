Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaJAR1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:27:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:40889 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaJAR1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:27:24 -0400
MIME-Version: 1.0
In-Reply-To: <1411367422-2095-1-git-send-email-ssreedharan@mvista.com>
References: <1411367422-2095-1-git-send-email-ssreedharan@mvista.com>
Date: Wed, 1 Oct 2014 10:27:20 -0700
Message-ID: <CAMAWPa9R5HtGKkV=Ya-ekynY5maespZ0Q6BjwJcX3LN3857ZjQ@mail.gmail.com>
Subject: Re: [PATCH] serial/core: Initialize the console pm state
From: Kevin Hilman <khilman@kernel.org>
To: Sudhir Sreedharan <ssreedharan@mvista.com>
Cc: linux-serial@vger.kernel.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        lkml <linux-kernel@vger.kernel.org>, olof@lixom.net,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 11:30 PM, Sudhir Sreedharan
<ssreedharan@mvista.com> wrote:
> For console devices having UART_CAP_SLEEP capability, the uart_pm_state has
> to be initialized to UART_PM_STATE_ON. Otherwise the LCR regiser values
> are reinitialized when uart_change_pm is called from uart_configure_port.
>
> Signed-off-by: Sudhir Sreedharan <ssreedharan@mvista.com>

Multiple boot failures on ARM[1] were bisected down to this patch.

How was this patch tested, and on which platforms?

Also, the changelog states that this should be done only for
UART_CAP_SLEEP, but the patch does it for every UART.

Greg, I suggest this patch be dropped from tty-next until it has been
better described and tested.

Kevin

[1] http://lists.linaro.org/pipermail/kernel-build-reports/2014-October/005550.html
