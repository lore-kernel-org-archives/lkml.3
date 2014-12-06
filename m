Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaLFD7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 22:59:23 -0500
Received: from a-pb-sasl-trial-quonix.pobox.com ([208.72.237.12]:61702 "EHLO
	a-pb-sasl-trial-quonix.pobox.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124AbaLFD7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 22:59:21 -0500
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2014 22:59:21 EST
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=uq+uRh
	Ds26EkelDyZlwnNvoCE7jHAfztxlWJPJ+MInVpl2hMAEG6QnSCoqUeKU+Ut0vUZo
	nK638dKcvyuVszAA+wiQjZ8aP9GPDtNJJHeZCxg/FRVlDQrLnH5EwV8bZKQbw2jU
	bapcdtjSJNi2jXrgJqe6dvvq6/KsGa5eAP/wY=
Message-ID: <54827D3C.3080401@pobox.com>
Date: Sat, 06 Dec 2014 12:51:24 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: david.e.box@linux.intel.com, wsa@the-dreams.de
CC: jdelvare@suse.de, arnd@arndb.de, maxime.ripard@free-electrons.com,
        dianders@chromium.org, u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, andrew@lunn.ch, sjg@chromium.org,
        markus.mayer@linaro.org, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        chiau.ee.chew@intel.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH V3 0/2] i2c-designware: Baytrail bus locking driver
References: <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com> <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 29FA83EA-7CFB-11E4-8555-42529F42C9D4-47602734!pb-smtp1.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/12/02 9:09, David E. Box wrote:
> Select Intel Baytrail platforms support PMIC's whose i2c bus may be controlled
> exclusively by platform hardware. This patch set adds support for i2c bus
> locking to the designware core and provides a driver module for managing
> the lock on these platforms. Since the lock on these systems isn't enumerable
> outside of the i2c platform driver, the locking functions are assigned at
> compile time.

Have you ever look into the hwspinlock framework?  It seems to me that
such an exclusive operation between CPUs and external hardware blocks
is exactly what hwspinlock is for.  Further more hwspinlock takes care
of exclusiveness between SMP cores.

Ideally I would expect i2c-designware to have hwspinlock lock/unlock
API calls on one I2C transaction, but it's not necessarily the case.
Introducing such platform hooks (acquire_lock and release_lock) and
keeping actual exclusive operataion outside the driver might be good
for various usecases/platforms.

   Shinya

