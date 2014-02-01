Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbaBABB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 20:01:57 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:49593 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbaBABB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 20:01:56 -0500
Date: Fri, 31 Jan 2014 18:01:50 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] of_mdio: Allow the DT to specify the phy ID and
 avoid autoprobing
Message-ID: <20140201010150.GB2519@obsidianresearch.com>
References: <1391205045-1751-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1391205045-1751-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <CAGVrzcbVo-Zzm9kLhiptf-qWgPH9XSs29mW8g2=g=Bq=PCb0_w@mail.gmail.com>
 <20140131225513.GA2519@obsidianresearch.com>
 <CAGVrzcZwkHSLJxpVsVY_6-VnsuODs0vGKcrcvSBzMEq3GWxqLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVrzcZwkHSLJxpVsVY_6-VnsuODs0vGKcrcvSBzMEq3GWxqLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 03:28:10PM -0800, Florian Fainelli wrote:
> - you tell of_mdiobus_register() to look for a reset phandle and have
> a reset controller release the PHY from reset before it tries to probe
> for it, because doing that could avoid doing the PHY out of reset
> sequence in a few dozen Ethernet drivers

I think this would be interesting, but difficult. Ideally you'd want
to keep the phy in reset until an ethernet driver attaches to it, and
reset it again once it detaches, so Linux would have to defer probing
the phy driver until an attach. Not sure what this would do for power
consumption, but reset might be lower power on phy's that don't have
an internal power down.

> The auto-probing bypass logic looks simple enough, and it does not
> require burying the reset logic behind a reset controller, which
> uses

Right, it closely matches what was happening in board files. FWIW,
this system was designed in 2005 for Linux 2.16 and this patch set fell
out of porting forward to 3.13 w/ DT.

Jason
