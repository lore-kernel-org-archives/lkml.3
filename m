Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaFOS4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 14:56:42 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:44399 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaFOS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 14:56:41 -0400
Date: Sun, 15 Jun 2014 20:56:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Bollinger <sethb@digi.com>,
        LinusTorvaldstorvalds@linux-foundation.org
Subject: Re: Linux 3.15: SPARC serial console regression
Message-ID: <20140615185635.GA22577@ravnborg.org>
References: <20140609205917.GA913@drone.musicnaut.iki.fi>
 <1402357697-20976-1-git-send-email-peter@hurleysoftware.com>
 <20140610192438.GA6846@ravnborg.org>
 <53977688.5080802@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53977688.5080802@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter.

On Tue, Jun 10, 2014 at 05:20:08PM -0400, Peter Hurley wrote:
> Hi Sam,
> 
> On 06/10/2014 03:24 PM, Sam Ravnborg wrote:
> >>From: Peter Hurley <peter@hurleysoftware.com>
> >>Date: Mon, 9 Jun 2014 19:21:43 -0400
> >>Subject: [PATCH] serial: sunsab: Test for no tx data on tx restart
> >>
> >>Commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c,
> >>'serial_core: Fix conditional start_tx on ring buffer not empty'
> >>exposes an incorrect assumption in sunsab's start_tx method; the
> >>tx ring buffer can, in fact, be empty when restarting tx when
> >>performing flow control.

We have a report that commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c
("serial_core: Fix conditional start_tx on ring buffer not empty")
broke at least one more driver:

    Aaro Koskinen <aaro.koskinen@iki.fi> reported:
    The same problem is present also on PowerPC G5 Xserve (pmac_zilog driver)

And based on code review a third driver is broken:

    Sam Ravnborg <sam@ravnborg.org> reported:
    Can you please take a look at sunzilog.c.
    It looks like the same test is missing in sunzilog_start_tx():

This is a regression so we should either revert the above commit
or review and fix the remaining drivers.

	Sam
