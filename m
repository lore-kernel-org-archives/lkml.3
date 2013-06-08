Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3FHJVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 05:21:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39507 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3FHJVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 05:21:45 -0400
Date: Sat, 8 Jun 2013 10:21:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonathan Cameron <jic23@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: Arm sub architectures missing clk_round_rate()
Message-ID: <20130608092133.GI18614@n2100.arm.linux.org.uk>
References: <51B2F1ED.2090801@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B2F1ED.2090801@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 08, 2013 at 09:57:17AM +0100, Jonathan Cameron wrote:
> At least one Arm subarch (pxa) does no provide an implementation of this
> function.  As far as I can see there is no way for a driver wishing to use
> it to detect it's absence.  This is marked in clk.h as being optional
> for 'Machine Class support'. Obvious solutions to this are:
> 
> 1) It is effectively only usable by platform specific drivers as no
>    more generic driver can know it is available.  Perhaps even a stub that
>    returns an appropriate error would be acceptable.
> 
> 2) It is not as optional as the header implies and should always be implemented
>    if the rest of the clk framework is.
> 
> 3) There should be some means of detecting its absense so that drivers can
>    be dependant on its presene.
> 
> Which is the correct one?

The right answer is (2) now that we have things like the clk framework and
soo many users.
