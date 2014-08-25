Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbaHYWUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 18:20:54 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56845 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751780AbaHYWUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 18:20:53 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linus.walleij@linaro.org, gnurou@gmail.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH] ACPI: Add GPIO-signaled event emulator.
Date: Tue, 26 Aug 2014 00:39:59 +0200
Message-ID: <1828087.V5efjsXTdI@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53F604B2.6020004@linaro.org>
References: <1408546700-19309-1-git-send-email-tomasz.nowicki@linaro.org> <20140821104533.GM1660@lahna.fi.intel.com> <53F604B2.6020004@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 21, 2014 04:39:46 PM Tomasz Nowicki wrote:
> Hi Mika,
> 
> On 21.08.2014 12:45, Mika Westerberg wrote:
> > On Wed, Aug 20, 2014 at 04:58:20PM +0200, Tomasz Nowicki wrote:

[cut]

> >> +
> >> +static int gpio_evt_trigger(void *data, u64 val)
> >> +{
> >> +	struct gpio_pin_data *pin_data = (struct gpio_pin_data *)data;
> >> +	int pin = pin_data->pin;
> >> +
> >> +	if (ACPI_FAILURE(acpi_execute_simple_method(pin_data->handle, NULL,
> >> +						    pin <= 255 ? 0 : pin)))
> >> +		pr_err(PREFIX "evaluating event method failed\n");
> >
> > acpi_execute_simple_method() passes one argument to the method. You
> > can't use it with _Lxx or _Exx which don't expect any arguments.
> > Otherwise you get this:
> >
> > [  122.258191] ACPI: \_SB_.GPO2._E12: Excess arguments - Caller passed 1, method requires 0 (20140724/nsarguments-263)
> Right, I will fix it.

OK, so here's my concern.

If AML does any kind of tracking of state in _Exx/_Lxx, you'll likely totally
confuse it by calling those things at random.

I'm not sure I'm seeing a compelling reason to put this thing into the tree
for this reason.

Rafael

