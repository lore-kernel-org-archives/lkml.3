Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3FHI5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 04:57:22 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:41160 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab3FHI5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 04:57:20 -0400
Message-ID: <51B2F1ED.2090801@kernel.org>
Date: Sat, 08 Jun 2013 09:57:17 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Arm sub architectures missing clk_round_rate()
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least one Arm subarch (pxa) does no provide an implementation of this
function.  As far as I can see there is no way for a driver wishing to use
it to detect it's absence.  This is marked in clk.h as being optional
for 'Machine Class support'. Obvious solutions to this are:

1) It is effectively only usable by platform specific drivers as no
   more generic driver can know it is available.  Perhaps even a stub that
   returns an appropriate error would be acceptable.

2) It is not as optional as the header implies and should always be implemented
   if the rest of the clk framework is.

3) There should be some means of detecting its absense so that drivers can
   be dependant on its presene.

Which is the correct one?

This issue came up as a result of the thread
http://marc.info/?l=linux-iio&m=137026653516438&w=2
[PATCH RESEND V2 3/4] iio: frequency: adf4350: Add support for clock consumer framework
on linux-iio@vger.kernel.org


Thanks,

Jonathan
