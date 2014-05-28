Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaE1UJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:09:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbaE1UJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:09:52 -0400
Date: Wed, 28 May 2014 13:13:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>, Alan <gnomes@lxorguk.ukuu.org.uk>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH V7] serial/uart/8250: Add tunable RX interrupt trigger
 I/F of FIFO buffers
Message-ID: <20140528201327.GA19249@kroah.com>
References: <20140527050921.17672.97365.stgit@yunodevel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527050921.17672.97365.stgit@yunodevel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 02:09:21PM +0900, Yoshihiro YUNOMAE wrote:
> Add tunable RX interrupt trigger I/F of FIFO buffers.
> 
> Serial devices are used as not only message communication devices but control
> or sending communication devices. For the latter uses, normally small data
> will be exchanged, so user applications want to receive data unit as soon as
> possible for real-time tendency. If we have a sensor which sends a 1 byte data
> each time and must control a device based on the sensor feedback, the RX
> interrupt should be triggered for each data.
> 
> According to HW specification of serial UART devices, RX interrupt trigger
> can be changed, but the trigger is hard-coded. For example, RX interrupt trigger
> in 16550A can be set to 1, 4, 8, or 14 bytes for HW, but current driver sets
> the trigger to only 8bytes.
> 
> This patch makes some devices change RX interrupt trigger from userland.

I'd prefer it if you could split the attr_grps logic out into a separate
patch, the first one in a 2 patch series.  I don't think it is quite
correct what you are doing here, but given the other changes going on at
the same time, it's hard to pick it apart.

So, can you split this up into 2 patches and resend please?

thanks,

greg k-h
