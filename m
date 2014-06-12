Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135AbaFLWC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:02:59 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:32824 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbaFLWC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:02:58 -0400
X-Sasl-enc: flPc3c/DRvuZN8xpWULseR3MEEFsqg39eamwt/0OBeZR 1402610569
Date: Thu, 12 Jun 2014 15:06:41 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH 0/2] thunderbolt: Fix issues with more complex endpoints.
Message-ID: <20140612220641.GC8176@kroah.com>
References: <1402607507-14858-1-git-send-email-andreas.noever@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402607507-14858-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 11:11:45PM +0200, Andreas Noever wrote:
> Hi,
> 
> I have got my hand on a slightly more complex Thunderbolt device (a Startech
> docking station). This series fixes the following issues that I have observed
> with this device:
> 
>  - Some ports on this device are disabled. Accessing them results in an error.
>  - This device uses both Thunderbolt links which are represented as two ports on
>    the switch. We have to ensure that we only scan one of these ports.
> 
> Part 1 of the series reads the switch configuration (disabled ports and which
> port pairs are "dual link ports") from eeprom. Part 2 uses this information to
> avoid scanning these ports.
> 
> Andreas Noever (2):
>   thunderbolt: Read port configuration from eeprom.
>   thunderbolt: Fix nontrivial endpoint devices.
> 
>  drivers/thunderbolt/ctl.c    |   2 +-
>  drivers/thunderbolt/eeprom.c | 266 ++++++++++++++++++++++++++++++++++++++++++-
>  drivers/thunderbolt/switch.c |  44 ++++---
>  drivers/thunderbolt/tb.c     |   5 +
>  drivers/thunderbolt/tb.h     |   7 +-
>  5 files changed, 300 insertions(+), 24 deletions(-)
> 
> -- 

Thanks, I'll queue these up on top of your other patches once 3.16-rc1
is out.

greg k-h
