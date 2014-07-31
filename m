Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaGaH7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:59:30 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36172 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbaGaH72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:59:28 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Thu, 31 Jul 2014 08:59:25 +0100
To: Matt Longnecker <mlongnecker@nvidia.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thermal: tell cooling devices when a trip_point changes
Message-ID: <20140731075924.GA2791@e104805>
References: <53D97B70.1050305@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <53D97B70.1050305@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 31 Jul 2014 07:59:25.0564 (UTC) FILETIME=[58B8BBC0:01CFAC95]
X-MC-Unique: 114073108592610101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 12:10:40AM +0100, Matt Longnecker wrote:
> Some hardware can react autonomously at a programmed temperature.
> For example, an SoC might implement a last ditch throttle or a
> hardware thermal shutdown. The driver for such a device can
> register itself as a cooling_device with the thermal framework.
> 
> With this change, the thermal framework notifies such a driver
> when userspace alters the relevant trip temperature so that
> the driver can reprogram its hardware

Why can't you just use the existing cooling device interface?  Cooling
devices can be bound to trip points.  Most thermal governors will
increase cooling for that cooling device when the trip point is hit.
The last ditch throttle or hardware thermal shutdown will then kick
when the cooling state changes to 1.

If the existing governors are too complex for what you want, you can
have a look at the bang bang governor[0] which (I think) is bound to
be merged soon.

[0] http://article.gmane.org/gmane.linux.kernel/1753348

Cheers,
Javi

