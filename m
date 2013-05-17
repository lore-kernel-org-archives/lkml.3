Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab3EQLst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:48:49 -0400
Received: from 8bytes.org ([85.214.48.195]:44049 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab3EQLss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:48:48 -0400
Date: Fri, 17 May 2013 13:48:45 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add missing lock in n_tty_write()
Message-ID: <20130517114845.GA2602@8bytes.org>
References: <20130515105656.GI24440@8bytes.org>
 <5193A3B5.7010400@suse.cz>
 <20130515154753.GJ24440@8bytes.org>
 <5193D7E0.5010803@hurleysoftware.com>
 <20130515194835.GK24440@8bytes.org>
 <519415F3.6060103@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519415F3.6060103@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri May 17 13:48:46 2013
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5196191e23346577232795
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

thanks for you explanations. They helped me to better understand what is
happening now.

On Wed, May 15, 2013 at 07:10:43PM -0400, Peter Hurley wrote:
> On 05/15/2013 03:48 PM, Joerg Roedel wrote:

> Agreed. Those functions look written for single-producer/single-consumer
> i/o model. (That's why I asked about CONFIG_CONSOLE_POLL=y as well because
> that doesn't look thread-safe either).

Ok, I checked that. CONFIG_CONSOLE_POLL is on in that kernel.

> Just to be clear here: there's a difference between a console driver
> and a tty driver.
> 
> The console driver's write() method is serialized with the global
> console_lock() so parallel console writes are not possible.
> 
> No such guarantee exists for the tty driver write() method, although it
> probably wouldn't be difficult to provide that guarantee (since the
> line discipline write() is already serialized by tty->atomic_write_lock).

Okay, so it is safe to say that currently the drivers write() (and
put_chars()) functions need to expect to be called concurrently and
therefore they have to serialize themselves when they need it, right?


	Joerg


