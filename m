Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaEETmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:42:37 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:64412 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaEETmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:42:35 -0400
From: Peter Korsgaard <peter@korsgaard.com>
To: monstr@monstr.eu
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, arnd@arndb.de,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] tty: serial: uartlite: Specify time for sending chars
References: <4c1854686987185d547d1d548f89248cb27ba40c.1399301297.git.michal.simek@xilinx.com>
	<874n14i7yn.fsf@dell.be.48ers.dk> <5367D76A.2040206@monstr.eu>
Date: Mon, 05 May 2014 21:42:31 +0200
In-Reply-To: <5367D76A.2040206@monstr.eu> (Michal Simek's message of "Mon, 05
	May 2014 20:24:42 +0200")
Message-ID: <87wqe0gggo.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Michal" == Michal Simek <monstr@monstr.eu> writes:

Hi,

 >> > diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
 >> > index 5f90ef24d475..723a6b79cd14 100644
 >> > --- a/drivers/tty/serial/uartlite.c
 >> > +++ b/drivers/tty/serial/uartlite.c
 >> > @@ -418,14 +418,20 @@ static struct uart_ops ulite_ops = {
 >> >  #ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
 >> >  static void ulite_console_wait_tx(struct uart_port *port)
 >> >  {
 >> > -	int i;
 >> >  	u8 val;
 >> > +	unsigned long timeout;
 >> 
 >> >  	/* Spin waiting for TX fifo to have space available */
 >> > -	for (i = 0; i < 100000; i++) {
 >> 
 >> It would be good to add a note about the slow jtag variant here.

 > What exactly you would like to see here?
 > Just that this 1s is here because of mdm uart.

Something like:

 /*
  * Spin waiting for TX fifo to have space available.
  * When using the Microblaze Debug Module this can take up to 1s
  */

-- 
Bye, Peter Korsgaard
