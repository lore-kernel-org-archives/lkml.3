Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3JaOH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:07:56 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:57117 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab3JaOHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:07:53 -0400
Date: Thu, 31 Oct 2013 15:07:47 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Bo Shen <voice.shen@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] misc: atmel_pwm: set initcall level to subsys
Message-ID: <20131031140747.GH29813@localhost>
References: <1382459560-26596-1-git-send-email-jhovold@gmail.com>
 <20131029232249.GA20476@kroah.com>
 <20131030110705.GA29813@localhost>
 <201310302146.18248.arnd@arndb.de>
 <5271B012.4060200@atmel.com>
 <20131031053037.GA30542@ns203013.ovh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031053037.GA30542@ns203013.ovh.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 06:30:37AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 09:19 Thu 31 Oct     , Bo Shen wrote:
> > Hi Arnd,
> > 
> > On 10/31/2013 04:46, Arnd Bergmann wrote:
> > >On Wednesday 30 October 2013, Johan Hovold wrote:
> > >>>I really hate this type of patch, as it's papering over the real
> > >>>problem.  What happens when someone else moves their driver to this
> > >>>level?  Then you are back to the original problem.
> > >>
> > >>Yes, it's crude, but it's currently the only way to express a preferred
> > >>probe order.
> > >
> > >Does the same problem occur with the generic PWM subsystem?
> > >
> > >The atmel_pwm driver apparently is the last PWM driver that has
> > >not been converted to the generic subsystem yet. Doing that would
> > >also let us drop the atmel-pwm-bl driver in favor of the generic
> > >backlight.
> > 
> > The atmel pwm driver is on the way to generic subsystem. more
> > information at:
> > --->8---
> > PWM: atmel-pwm: add PWM controller driver:
> >    https://patchwork.kernel.org/patch/2963081/
> 
> so the fix can be drop in favor of the conversion

This patch (2/2) has been dropped, but the dependency issue still has to
be addressed (by adding deferred-probing support). The atmel-pwm-bl
driver has not been removed yet and the fix is also needed in stable.

Johan
