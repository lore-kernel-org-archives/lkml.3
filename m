Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaGJOce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:32:34 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40924 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaGJOcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:32:32 -0400
Date: Thu, 10 Jul 2014 15:31:57 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Stephen Warren <swarren@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH V8 2/2] serial/uart/8250: Add tunable RX interrupt
 trigger I/F of FIFO buffers
Message-ID: <20140710153157.57902972@alan.etchedpixels.co.uk>
In-Reply-To: <20140710002837.GA5429@kroah.com>
References: <20140530061617.21929.25777.stgit@yunodevel>
	<20140530061622.21929.82083.stgit@yunodevel>
	<20140710002837.GA5429@kroah.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I really don't like the way that the tty core has been changed to handle
> multiple attribute groups, as I feel tty drivers shouldn't be creating
> "special" sysfs files, depending on what driver is bound to them.

The intent isn't that it is "special" but that it can be propogated to
others as and when they wish to provide it.
 
> Usually we have handled this using tools like 'stty' and ioctls, right?
> Surely there is an ioctl to control the interrupt level, right?  Hasn't
> this been covered before somehow?

No, and the direction when this started was to use sysfs as we have also
been moving all the other attributes towards sysfs and has been since
2012.

TTY devices do have lots of strange attributes and right now many of them
are only programmable by using device tree and rebooting.

Alan
