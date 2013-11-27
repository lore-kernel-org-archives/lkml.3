Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3K0WAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:00:04 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:35461 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab3K0WAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:00:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Wed, 27 Nov 2013 23:03:43 +0100
From: Stefan Agner <stefan@agner.ch>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: thierry.reding@gmail.com, sameo@linux.intel.com, dev@lynxeye.de,
        mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: tegra: set SM2 voltage correct
In-Reply-To: <5296281C.1060403@wwwdotorg.org>
References: <cover.1385508112.git.stefan@agner.ch>
 <c9ceead9e3df77b5a33ad654db23c241cd624096.1385508112.git.stefan@agner.ch>
 <5296281C.1060403@wwwdotorg.org>
Message-ID: <da3ea685e652f3ce33ebbe660312ed01@agner.ch>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2013-11-27 18:13, schrieb Stephen Warren:
> On 11/26/2013 04:45 PM, Stefan Agner wrote:
>> Set the requested SM2 voltage to the correct value of 1.8V. The value
>> before used to work on TPS658623 since the driver applied a wrong
>> voltage table too. However, the TPS658643 used on newer devices uses
>> yet another voltage table and those broke that compatibility. The
>> regulator driver now has the correct voltage table for both regulator
>> versions and those the correct voltage can be used in this device
>> tree.
> 
> One thing you haven't called out explicitly here is that this series is
> an incompatible change to the DT, since the old buggy driver used to
> allow old buggy DT content to accidentally work.
> 
> I'm not too familiar with who's using mainline on the Colibri boards.
> Hopefully everyone doing that is using in-kernel DTs, so this
> incompatible change won't be any issue for anyone.
> 

I don't think there are a lot of users since Toradex ships the NVidia
downstream kernel. Two users for sure, Lucas and me.

> This patch needs to be rolled into patch 2/3 so that "git bisect" isn't
> broken.

Will do

 
> You mention there's yet another PMIC version used on later boards. Do we
> need a new DT for that specfic version of the Colibri board?

The newer device is the TPS658643, which uses a different voltage table,
but this change is already in the driver. Maybe I should reword that
commit a bit. I just tried to point out why the change is really needed
(since we have two regulators with different voltage tables). But there
is nothing beyond those two that... 

Because the DT now states the real, required voltage, a new device
(version) would need an appropriate driver change and things should
work.

