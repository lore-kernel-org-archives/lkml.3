Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab3JKUn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:43:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:59608 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682Ab3JKUnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:43:52 -0400
Message-ID: <1381524204.5630.91.camel@pasglop>
Subject: Re: [PATCH 1/2] tty/hvc_console: Add DTR/RTS callback to handle
 HUPCL control
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: jslaby@suse.cz, gregkh@linuxfoundation.org, brueckner@linux.vnet.com,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Date: Sat, 12 Oct 2013 07:43:24 +1100
In-Reply-To: <20131011124707.GA6082@linux.vnet.ibm.com>
References: <1372777635-10423-1-git-send-email-brueckner@linux.vnet.ibm.com>
	 <1372777635-10423-2-git-send-email-brueckner@linux.vnet.ibm.com>
	 <1381475711.5630.67.camel@pasglop>
	 <20131011124707.GA6082@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 14:47 +0200, Hendrik Brueckner wrote:
> The tiocmget/tiocmset callbacks are used to set and get modem status and
> triggered through an tty ioctl.
> 
> The dtr_rts() callback is different and it is used for DTS/RTS handshaking
> between the hvc_console (or any other tty_port) and the tty layer.  The tty
> port layer uses this callback to signal the hvc_console whether to raise or
> lower the DTR/RTS lines.  This is different than the ioctl interface to
> controls the modem status.

Well, DTR at least is the same via both callbacks... Also normal handshaking
is normally RTS/CTS, only some HW setups "hijacks" DTR for RTS (old Macs come
to mind).

Cheers,
Ben.


