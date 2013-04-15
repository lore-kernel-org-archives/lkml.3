Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3DOIzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:55:14 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:43862 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3DOIzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:55:12 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: drivers/base/core.c: about device_find_child() function
Date: Mon, 15 Apr 2013 10:55:11 +0200
Message-ID: <6047971.1xXAvlS68s@harkonnen>
User-Agent: KMail/4.10.1 (Linux/3.8.5-201.fc18.x86_64; KDE/4.10.1; x86_64; ; )
In-Reply-To: <20130412220633.GA16524@kroah.com>
References: <3798489.yISokZugC2@harkonnen> <2849474.HO2K6X9Bdi@harkonnen> <20130412220633.GA16524@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much Greg
 
> > I did not study serial_core, I was looking only for device_find_child().
> > Probably I'm missing something. Anyway, here what does not convice me:
> > 
> > (line number on next-20130412)
> > serial_core.c:2003
> > 
> > 	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
> > 	if (!uport->suspended && device_may_wakeup(tty_dev)) {
> > 	
> > 		if (uport->irq_wake) {
> > 		
> > 			disable_irq_wake(uport->irq);
> > 			uport->irq_wake = 0;
> > 		
> > 		}
> > 
> > +               put_device(tty_dev);
> > 
> > 		mutex_unlock(&port->mutex);
> > 		return 0;
> > 	
> > 	}
> > 
> > +	put_device(tty_dev);
> > 
> > 	uport->suspended = 0;
> > 
> > serial_core:1936
> > 
> > 	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
> > 	if (device_may_wakeup(tty_dev)) {
> > 	
> > 		if (!enable_irq_wake(uport->irq))
> > 		
> > 			uport->irq_wake = 1;
> > 		
> > 		put_device(tty_dev);
> > 		mutex_unlock(&port->mutex);
> > 		return 0;
> > 	
> > 	}
> > 
> > +	put_device(tty_dev);
> 
> That looks like a good patch, care to properly send it, (after you test
> it first of course), so that we can apply it?

Yes, I can do it and test it. I hope to find the time for a test in these 
days.

-- 
Federico Vaga
