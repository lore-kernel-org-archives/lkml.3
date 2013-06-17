Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab3FQJCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:02:36 -0400
Received: from mail.abilis.ch ([195.70.19.74]:27256 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab3FQJCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:02:35 -0400
Date: Mon, 17 Jun 2013 11:01:33 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] i2c: designware: fix race between subsequent xfers
Message-ID: <20130617090131.GC19380@ab42.lan>
References: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
 <1370595083-801-1-git-send-email-christian.ruppert@abilis.com>
 <20130614143740.GD2929@katana>
 <20130617081931.GB19380@ab42.lan>
 <20130617103336.354022c2@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130617103336.354022c2@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 10:33:36AM +0200, Jean Delvare wrote:
> On Mon, 17 Jun 2013 10:19:33 +0200, Christian Ruppert wrote:
> > On Fri, Jun 14, 2013 at 04:37:41PM +0200, Wolfram Sang wrote:
> > > BTW since I am currently here: i2c-designware-core should be in the
> > > 'algos' directory, no?
> > 
> > At the risk of passing for a complete moron: What exactly is the
> > difference between I2C algos and I2C bus drivers?
> 
> The i2c/algos directory contains abstracted code which is common to
> multiple hardware implementations. The most popular of these is
> i2c-algo-bit which implements software-only I2C over virtually any pair
> of controllable pins (parallel port, GPIOs, etc.)
> 
> As a general rule, i2c/algos should only contain reusable, architecture
> and platform independent code. All the actual hardware access should be
> delegated to the bus drivers, through callbacks. If this can't be done
> easily then i2c/algos is not the right place.

In this case, busses is the right place for the i2c-designware-core. This
file contains the actual driver implementation (i.e. register access,
interrupt handling etc.) for a dedicated I2C bus driver hardware block
used in SOCs.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
