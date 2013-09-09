Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab3IIECy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 00:02:54 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:60194 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3IIECx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 00:02:53 -0400
X-Originating-IP: 50.43.39.152
Date: Sun, 8 Sep 2013 21:02:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: paul.mckenney@linaro.org, akpm@linux-foundation.org, decot@googlers.com,
        amirv@mellanox.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] genirq: add IRQF_NONE
Message-ID: <20130909040244.GA1157@leaf>
References: <1378698519-4780-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378698519-4780-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 05:48:39AM +0200, Michael Opdenacker wrote:
> What about adding an IRQF_NONE flag as in the below patch?
> 
> I'm currently working on removing the use of the deprecated
> IRQF_DISABLED flag, and frequently have to replace
> IRQF_DISABLED by 0, typically in request_irq() arguments.
> 
> Using IRQF_NONE instead of 0 would make the code more readable,
> at least for people reading driver code for the first time.
> 
> Would it worth it?
> 
> I'm sure this kind of idea has come up many times before...
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

I don't think it makes sense, no; it's a flags field, meant to receive a
set of flags, and 0 is the standard empty set of flags.  I think
IRQF_NONE would actually reduce readability, especially for readers who
haven't seen it before, because it isn't immediately obvious that it
just corresponds to the 0 of "no flags".  My first guess reading it
would be that it's some non-zero flag with some non-obvious semantic,
such as "don't actually allocate an IRQ", or something strange like
that.

- Josh Triplett
