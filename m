Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab3K0RNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:13:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59718 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab3K0RNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:13:02 -0500
Message-ID: <5296281C.1060403@wwwdotorg.org>
Date: Wed, 27 Nov 2013 10:13:00 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, thierry.reding@gmail.com,
        sameo@linux.intel.com, dev@lynxeye.de
CC: mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: tegra: set SM2 voltage correct
References: <cover.1385508112.git.stefan@agner.ch> <c9ceead9e3df77b5a33ad654db23c241cd624096.1385508112.git.stefan@agner.ch>
In-Reply-To: <c9ceead9e3df77b5a33ad654db23c241cd624096.1385508112.git.stefan@agner.ch>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 04:45 PM, Stefan Agner wrote:
> Set the requested SM2 voltage to the correct value of 1.8V. The value
> before used to work on TPS658623 since the driver applied a wrong
> voltage table too. However, the TPS658643 used on newer devices uses
> yet another voltage table and those broke that compatibility. The
> regulator driver now has the correct voltage table for both regulator
> versions and those the correct voltage can be used in this device
> tree.

One thing you haven't called out explicitly here is that this series is
an incompatible change to the DT, since the old buggy driver used to
allow old buggy DT content to accidentally work.

I'm not too familiar with who's using mainline on the Colibri boards.
Hopefully everyone doing that is using in-kernel DTs, so this
incompatible change won't be any issue for anyone.

This patch needs to be rolled into patch 2/3 so that "git bisect" isn't
broken.

You mention there's yet another PMIC version used on later boards. Do we
need a new DT for that specfic version of the Colibri board?
