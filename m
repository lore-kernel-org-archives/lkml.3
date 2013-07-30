Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3G3SlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:41:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52173 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755926Ab3G3SlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:41:18 -0400
Message-ID: <1375209677.2075.129.camel@joe-AO722>
Subject: Re: [PATCH v3 1/3] net/usb/r815x: replace USB buffer from stack to
 DMA-able
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: gregkh@linuxfoundation.org, hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com
Date: Tue, 30 Jul 2013 11:41:17 -0700
In-Reply-To: <20130730.113329.1450325193505423812.davem@davemloft.net>
References: <D7C722C73C7A400780358D0376412267@realtek.com.tw>
	 <1375172936-4145-1-git-send-email-hayeswang@realtek.com>
	 <20130730140059.GE27962@kroah.com>
	 <20130730.113329.1450325193505423812.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 11:33 -0700, David Miller wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> Date: Tue, 30 Jul 2013 07:00:59 -0700
> 
> > This call is so slow, you can afford to make a call to kmalloc for the
> > data, as it sure just did for other structures it needed :)
> 
> I told him to implement things this way, to avoid calling kmalloc every
> single register access.
> 
> Using kmalloc all the time makes the access fragile, since a badly timed
> call during high memory pressure can fail.
> 
> I'd rather the potential failure happen at one time, probe time.
> 
> In any event, Ming Lei has suggested using usbnet_{read,write}_cmd()
> instead, which sounds like a good solution to this problem.

Those do per-call allocs too.


