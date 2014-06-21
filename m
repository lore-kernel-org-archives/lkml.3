Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469AbaFUKwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 06:52:51 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:48906 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbaFUKwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 06:52:49 -0400
Date: Sat, 21 Jun 2014 12:52:05 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: SmPL for automatic request_firmware_nowait() conversion
Message-ID: <20140621105205.GA31611@electric-eye.fr.zoreil.com>
References: <20140621015714.GX4841@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140621015714.GX4841@wotan.suse.de>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez <mcgrof@suse.com> :
> I was just porting over an ethernet driver [0] to use request_firmware_nowait()
> since firmware loading seems can take over a minute on one device, while
> at it I noticed no other ethernet drivers yet use this API so figure
> this may be a trend coming if devices are getting as complex as cxgb4.
> The cxgb4 driver happens to even use the firmware API 3 times!

There should be no problem for the firmware requests issued through
ethtool in cxgb4.

[...]
> netdev: how worthy is this effort?

Biased comment below :o)

I'm wondering the benefit of automatic API changes when it could be argued
that the symptoms call for driver dependant code rework.

The 60 seconds delay is kind of a pavlovian signal: one can bet that the
driver includes a request_firmware in its probe method. So does cxgb4.

I still believe in the old school "request firmware from net_device_ops.open".
I've been happy with it since f1e02ed109df5f99abf942b8ccc99960cb09dd38.
This kind of rework may not be trivial for cxgb4. Please get code tested on
real hardware (modular/monolithic build, with/without firmware, etc.) as I
won't argue against your crusade for cxgb4.

Asynchronous firmware loading provides a rather nice high level API but
it's imho not the essence of network devices firmware loading problems.

-- 
Ueimor
