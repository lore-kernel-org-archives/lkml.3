Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaKLJaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:30:35 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:50295 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaKLJ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:29:55 -0500
Date: Wed, 12 Nov 2014 10:29:52 +0100
From: Johan Hovold <johan@kernel.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 8/9] net: phy: micrel: clean up led-mode setup
Message-ID: <20141112092952.GD15215@localhost>
References: <1415732415-10363-1-git-send-email-johan@kernel.org>
 <1415732415-10363-9-git-send-email-johan@kernel.org>
 <5462828B.8090303@cogentembedded.com>
 <546282EA.7040508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546282EA.7040508@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 01:43:06PM -0800, Florian Fainelli wrote:
> On 11/11/2014 01:41 PM, Sergei Shtylyov wrote:
> > Hello.
> > 
> > On 11/11/2014 10:00 PM, Johan Hovold wrote:
> > 
> >> Clean up led-mode setup by introducing proper defines for PHY Control
> >> registers 1 and 2 and only passing the register to the setup function.
> > 
> >    Not sure that's really better that it was before (modulo naming).
> 
> We do have proper error handling in kszphy_setup_led() which is already
> an improvement.

This also means handling the led mode in one place rather than spreading
it all over the driver, with multiple config functions providing one of
the same two combinations of register and shift.

It's usefulness will perhaps become more apparent if you look at the
follow up patches, which does further refactoring and store the led-mode
register in the type data.

Johan
