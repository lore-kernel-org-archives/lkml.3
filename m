Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab3JKMsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:48:32 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:51238 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932Ab3JKMsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:48:30 -0400
Date: Fri, 11 Oct 2013 14:47:07 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>, jslaby@suse.cz,
        gregkh@linuxfoundation.org, brueckner@linux.vnet.com,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 1/2] tty/hvc_console: Add DTR/RTS callback to handle
 HUPCL control
Message-ID: <20131011124707.GA6082@linux.vnet.ibm.com>
Mail-Followup-To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	jslaby@suse.cz, gregkh@linuxfoundation.org,
	brueckner@linux.vnet.com, heiko.carstens@de.ibm.com,
	schwidefsky@de.ibm.com, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
References: <1372777635-10423-1-git-send-email-brueckner@linux.vnet.ibm.com>
 <1372777635-10423-2-git-send-email-brueckner@linux.vnet.ibm.com>
 <1381475711.5630.67.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381475711.5630.67.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101112-5024-0000-0000-0000077B9DA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Fri, Oct 11, 2013 at 06:15:11PM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2013-07-02 at 17:07 +0200, Hendrik Brueckner wrote:
> > Introduce a new callback to explicitly handle the HUPCL termios control flag.
> > This prepares for a follow-up commit for the hvc_iucv device driver to
> > improve handling when to drop an established network connection.
> > 
> > The callback naming is based on the recently added tty_port interface to
> > facilitate a potential refactoring of the hvc_console to use tty_port
> > functions.
> 
> I only just noticed that ... oops. Why add those dtr_rts() calls ? We
> already have tiocmset in there which is used to set DTR on HVSI consoles
> such as hvc_opal when using hvsi_lib...
> 
> Any reason why a separate callback was needed ?

The tiocmget/tiocmset callbacks are used to set and get modem status and
triggered through an tty ioctl.

The dtr_rts() callback is different and it is used for DTS/RTS handshaking
between the hvc_console (or any other tty_port) and the tty layer.  The tty
port layer uses this callback to signal the hvc_console whether to raise or
lower the DTR/RTS lines.  This is different than the ioctl interface to
controls the modem status.

Thanks and kind regards,
  Hendrik

