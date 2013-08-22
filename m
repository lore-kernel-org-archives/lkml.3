Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab3HVR2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:28:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58343 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab3HVR2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:28:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Turquette <mturquette@linaro.org>
Subject: Re: [RFC 02/17] ARM: call clk_of_init from time_init
Date: Thu, 22 Aug 2013 19:28:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <201308212054.10417.arnd@arndb.de> <20130822072524.8231.37219@quantum>
In-Reply-To: <20130822072524.8231.37219@quantum>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308221928.10852.arnd@arndb.de>
X-Provags-ID: V02:K0:cAhpPzNe5dVnSaYrWuO3CiKjWDpX6V//ptMidFURNG8
 J6i8AZ26hrZxmd07B1Dg9t6uv40tY9JxsIpA45qe0GOCvAS+o2
 aOpQ6PBhA0zSoPeiXkGz7tyoWzBYduqnxsKlicsoPmQMDKTPSz
 iTwCT2FRnlv1TCntqfJoV3n8kTWKJ0wltYyVsfncVLjX1kgY//
 alsnOTcqYqJd6nXpZL1lOeXPBKiWVti3o9AvtCqFfZKnAj8xNa
 2KZylTxdtrIYBr61V1z8puGdmST8ix2uiaCY8Hz8eDCRmmvOAR
 UW1RkeZiXC18DoqbrOj/2NK11LDLfWcKaUP4zWoASnniDJ9vCP
 PETmLfHT8t+iD1SON3cU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 August 2013, Mike Turquette wrote:
> Some timers need to know their clock rate for the timer setup. This
> could be hard-coded (e.g. for some timer driven from a fixed 32Khz
> source) but it could also be from a clock capable of different rates
> that needs to be calculated.
> 
> I remember discussing the early clock init stuff for OMAP and there was
> an idea to not rely on the clock framework for timer init and just do
> some raw reads and compute the clock rate that way. Using the framework
> would be better of course.
> 

Just to be clear: I think we should initialize all clocks before timers,
just not any earlier like Tegra does.

	Arnd
