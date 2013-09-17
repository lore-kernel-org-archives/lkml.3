Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3IQBOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 21:14:21 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62948 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751489Ab3IQBOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 21:14:17 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mark Brown <broonie@kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client devices
Date: Tue, 17 Sep 2013 03:25:25 +0200
Message-ID: <1820315.QOOAzSjac3@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130916233111.GB21013@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com> <1861747.RtS0ZLgUUN@vostro.rjw.lan> <20130916233111.GB21013@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 17, 2013 12:31:11 AM Mark Brown wrote:
> On Mon, Sep 16, 2013 at 09:07:07PM +0200, Rafael J. Wysocki wrote:
> 
> > That may be left to the client driver altogether.  I mean, if the client wants
> > the controller to be powered up, it should just call
> > pm_runtime_get_sync(controller device) at a suitable place (and then do the
> > corresponding _put when the controller is not necessary anu more) from its
> > ->probe() callback.
> 
> It shouldn't even need to do that, it should just be able to rely on the
> controller to power itself up when asked to do work.   This is how the
> existing implementations are done - the controller power management is
> totally transparent to the slave.

If both the I2C client and I2C controller have corresponding objects in the
ACPI namespace and the client's object is a child of the controller's object,
then in order to power up the client we need to power up the controller even
if no transactions are going to be carried out.  That's what the spec simply
requires us to do in that case.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
