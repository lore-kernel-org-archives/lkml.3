Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3DPJSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:18:44 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:15456 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab3DPJSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:18:43 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "Mark Brown (broonie@opensource.wolfsonmicro.com)" 
	<broonie@opensource.wolfsonmicro.com>
Subject: RE: [NEW DRIVER V4 0/7] DA9058 PMIC - please comment on this new
 driver
Thread-Topic: [NEW DRIVER V4 0/7] DA9058 PMIC - please comment on this new
 driver
Thread-Index: AQHON38JlZ8CqfSx5U6QnznQ+FhcK5jS0W+AgAW1MsA=
Date: Tue, 16 Apr 2013 09:18:41 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB514191E2DC@NB-EX-MBX02.diasemi.com>
References: <201304121307.r3CD7tDi011782@latitude>
 <1854273.arIzJJ3lWV@dtor-d630.eng.vmware.com>
In-Reply-To: <1854273.arIzJJ3lWV@dtor-d630.eng.vmware.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.109]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 12 April 2013 19:07
> To: Opensource [Anthony Olech]
> Cc: LKML; Alessandro Zummo
> Subject: Re: [NEW DRIVER V4 0/7] DA9058 PMIC - please comment on this new driver
> On Friday, April 12, 2013 02:05:29 PM Anthony Olech wrote:
> > This is submission attempt number 4 to have this driver included in
> > the linux kernel source tree. This is the driver for the Dialog DA9058.
> > The DA9058 is a low power Power Management Integrated Circuit with
> > extra functionality. It is a Multi Function Device controlled only
> > from an I2C bus whose components can raise an interrupt request on a single IRQ line.
> > The driver for the DA9058 consists of a core (i2c) device driver that
> > instantiates the individual component device drivers for:
> > adc - 5 ADC channels
> > gpio - 2 available pins
> > onkey - 1 device
> 
> > This is almost exact copy of da9052_onkey, can they be merged together?
>
> Dmitry

Hi Dmitry,

it does look like the ONKEY component driver of the Dialog DA9058 PMIC is
functionally similar to other onkey drivers. Specifically those drivers that have
to poll for ONKEY de-assertion.

The reason why they are separate is that they are probed with different data
structures and they use a different wrapper to access the "regmap" API.
However, that is not a blocking issue, but it would mean re-writing the core
MFD component of all the affected drivers. Maybe the way forward is:

Is it possible to provide some "core" ONKEY API or functionality to handle the
commonality in a similar fashion to the regulator core as done by Mark Brown?

Tony Olech
