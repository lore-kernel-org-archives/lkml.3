Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3JaOBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:01:47 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:57525 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3JaOBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:01:45 -0400
Date: Thu, 31 Oct 2013 15:01:40 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] misc: atmel_pwm: set initcall level to subsys
Message-ID: <20131031140140.GG29813@localhost>
References: <1382459560-26596-1-git-send-email-jhovold@gmail.com>
 <20131029232249.GA20476@kroah.com>
 <20131030110705.GA29813@localhost>
 <201310302146.18248.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310302146.18248.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 09:46:17PM +0100, Arnd Bergmann wrote:
> On Wednesday 30 October 2013, Johan Hovold wrote:
> > > I really hate this type of patch, as it's papering over the real
> > > problem.  What happens when someone else moves their driver to this
> > > level?  Then you are back to the original problem.
> > 
> > Yes, it's crude, but it's currently the only way to express a preferred
> > probe order.
> 
> Does the same problem occur with the generic PWM subsystem?

It does not suffer from the problem with failed probe as it supports
deferred probing, but there could be added delays depending on probe
order.

> The atmel_pwm driver apparently is the last PWM driver that has
> not been converted to the generic subsystem yet. Doing that would
> also let us drop the atmel-pwm-bl driver in favor of the generic
> backlight.

As Bo mentioned, it's work in progress that hasn't been merged yet.

Johan
