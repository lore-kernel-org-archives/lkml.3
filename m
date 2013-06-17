Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3FQIUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:20:38 -0400
Received: from mail.abilis.ch ([195.70.19.74]:14894 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab3FQIUg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:20:36 -0400
Date: Mon, 17 Jun 2013 10:19:33 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] i2c: designware: fix race between subsequent xfers
Message-ID: <20130617081931.GB19380@ab42.lan>
References: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
 <1370595083-801-1-git-send-email-christian.ruppert@abilis.com>
 <20130614143740.GD2929@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130614143740.GD2929@katana>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 04:37:41PM +0200, Wolfram Sang wrote:
> On Fri, Jun 07, 2013 at 10:51:23AM +0200, Christian Ruppert wrote:
> [...]
> > +	/*
> > +	 * We must disable the adapter before unlocking the &dev->lock mutex
> > +	 * below. Otherwise the hardware might continue generating interrupts
> > +	 * which in turn causes a race condition with the following transfer.
> 
> I added "Needs some more investigation if the additional interrupts are
> a hardware bug or this driver doesn't handle them correctly yet." to the
> comment and

Good idea, thanks.

> Applied to for-next, thanks!
> 
> BTW since I am currently here: i2c-designware-core should be in the
> 'algos' directory, no?

At the risk of passing for a complete moron: What exactly is the
difference between I2C algos and I2C bus drivers?

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
