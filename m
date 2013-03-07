Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693Ab3CGS5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:57:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab3CGS52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:57:28 -0500
Date: Thu, 7 Mar 2013 13:56:42 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 8250.nr_uarts broken in 3.7
Message-ID: <20130307185642.GF13719@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We've had a report [1] in Fedora that the nr_uarts parameter on the 8250
serial driver is no longer working.  Our config hasn't changed in this
area in quite a while, and dmesg clearly shows setting 8250.nr_uarts=16
on the kernel command line results in:

[    0.345459] Serial: 8250/16550 driver, 16 ports, IRQ sharing enabled

whereas if you boot a 3.7 kernel with the same setting it prints out the
default value of 4 for ports.  Fedora builds 8250 into the kernel and
not as a module, but the option is still clearly parsed in that case for
3.6.

I've looked through the commits from 3.6..3.7 in the 8250 driver and the
only one that seems relevant at all is

commit 835d844d1a28efba81d5aca7385e24c29d3a6db2
Author: Sean Young <sean@mess.org>
Date:   Fri Sep 7 19:06:23 2012 +0100

    8250_pnp: do pnp probe before legacy probe

but that is simply moving code around.

I ran the same test on a 3.9-rc1 kernel and it isn't being picked up
there either.  Before I go off and do a bisect to track this down, has
anyone else seen or heard of this no longer working?

josh
