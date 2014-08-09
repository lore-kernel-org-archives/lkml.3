Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaHIPr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 11:47:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35184 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaHIPr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 11:47:26 -0400
Date: Sat, 9 Aug 2014 17:47:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Miguel Oliveira <cmroliv@gmail.com>, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nokia_h4: merge firmware together so that we
 can reduce ammount of exports
Message-ID: <20140809154724.GA6771@amd.pavel.ucw.cz>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530123023.GA10549@amd.pavel.ucw.cz>
 <20140530155959.GA10682@kroah.com>
 <201405301815.10811@pali>
 <20140530163604.GA11943@kroah.com>
 <DB71A450-EF1D-479F-9111-A36FF8EA89B2@holtmann.org>
 <20140806213055.GA26046@amd.pavel.ucw.cz>
 <20140807002532.GB23406@kroah.com>
 <20140807090733.GC24700@amd.pavel.ucw.cz>
 <FAB4A38E-6DFE-48FA-9D52-258DD77A39B6@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FAB4A38E-6DFE-48FA-9D52-258DD77A39B6@holtmann.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > +
> > +	skb_queue_tail(&info->txq, fw_skb);
> > +	spin_lock_irqsave(&info->lock, flags);
> > +	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
> > +			UART_IER_THRI);
> > +	spin_unlock_irqrestore(&info->lock, flags);
> > +}
> 
> and as I explained before, this crazy can not continue. Bluetooth drivers can provide a hdev->setup callback for loading firmware and doing other setup details. You can just bring up the HCI transport. We are providing __hci_cmd_sync for easy loading of the firmware. Especially if the firmware just consists of HCI commands. Which is clearly the case with the Nokia firmware files.
> 

I know that this crazyness can not continue; but I need to be able to
move "bad" code around to get the cleanups, ok? Because you also asked
me to reduce ammount of exports.

Best regards,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
