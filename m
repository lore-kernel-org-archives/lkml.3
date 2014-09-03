Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbaICOVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:21:25 -0400
Received: from doppler.thel33t.co.uk ([193.110.88.198]:45236 "EHLO
	doppler.thel33t.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573AbaICOVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:21:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Sep 2014 15:40:56 +0100
From: Leigh Brown <leigh@solinno.co.uk>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Raphael Rigo <ml-arm@syscall.eu>, Arnaud Ebalard <arno@natisbad.org>,
        Simon Boulay <simon.boulay@vitec.com>
Subject: Re: [PATCH V2 0/4] clk: mvebu: Improve clock drift
In-Reply-To: <1409645719-20003-1-git-send-email-gregory.clement@free-electrons.com>
References: <1409645719-20003-1-git-send-email-gregory.clement@free-electrons.com>
Message-ID: <902cee907da9c532822dcf5db722b47c@doppler.thel33t.co.uk>
User-Agent: Roundcube Webmail/1.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-02 09:15, Gregory CLEMENT wrote:
> Few users reported a timer drift on the Armada 370 based board such as
> the mirabox or the Netgear ReadyNAS 102. This is the second series
> with few improvements after the review of the 1st version.
> 
> The reason is that when the SSCG (Spread Spectrum Clock Generator) is
> enabled, it shifts the frequency of the clock. The percentage is no
> more than 1% but when the clock is used for a timer it leads to a
> clock drift.
> 
> This series allows to correct the affected clock when the SSCG is
> enabled. This drift can happen on all the mvebu SoC on the cpu clock
> block (ie cpu, ddr and l2 cache). Currently the only notable effect is
> for the Armada 370 because this SoC use the l2cache clock as source
> for the timer. That's why even if the series allow any of the mvebu
> SoC to benefit to this correction, Armada 370 is the only user of it.
> 
> The first 2 patches should go through the clk subsystem, whereas the
> third one should go to the arm-soc through the mvebu tree.
> 
> The last one is just to fix a typo I found while I was reading the clk
> code.

This is working superbly for me on my Mirabox, and ntpd is now 
completely stable.

Tested-by: Leigh Brown <leigh@solinno.co.uk>

