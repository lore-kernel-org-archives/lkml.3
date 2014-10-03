Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaJCEgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 00:36:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaJCEgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 00:36:10 -0400
Date: Thu, 2 Oct 2014 21:35:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: Sudhir Sreedharan <ssreedharan@mvista.com>, linux-serial@vger.kernel.org,
        jslaby@suse.cz, lkml <linux-kernel@vger.kernel.org>, olof@lixom.net,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] serial/core: Initialize the console pm state
Message-ID: <20141003043513.GA21327@kroah.com>
References: <1411367422-2095-1-git-send-email-ssreedharan@mvista.com>
 <CAMAWPa9R5HtGKkV=Ya-ekynY5maespZ0Q6BjwJcX3LN3857ZjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMAWPa9R5HtGKkV=Ya-ekynY5maespZ0Q6BjwJcX3LN3857ZjQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:27:20AM -0700, Kevin Hilman wrote:
> On Sun, Sep 21, 2014 at 11:30 PM, Sudhir Sreedharan
> <ssreedharan@mvista.com> wrote:
> > For console devices having UART_CAP_SLEEP capability, the uart_pm_state has
> > to be initialized to UART_PM_STATE_ON. Otherwise the LCR regiser values
> > are reinitialized when uart_change_pm is called from uart_configure_port.
> >
> > Signed-off-by: Sudhir Sreedharan <ssreedharan@mvista.com>
> 
> Multiple boot failures on ARM[1] were bisected down to this patch.
> 
> How was this patch tested, and on which platforms?
> 
> Also, the changelog states that this should be done only for
> UART_CAP_SLEEP, but the patch does it for every UART.
> 
> Greg, I suggest this patch be dropped from tty-next until it has been
> better described and tested.

Now reverted, thanks for letting me know.

greg k-h
