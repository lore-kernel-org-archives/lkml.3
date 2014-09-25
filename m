Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaIYT2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:28:10 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:33938 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaIYT2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:28:08 -0400
Message-ID: <1411673277.28648.5.camel@mm-sol.com>
Subject: Re: [PATCH v3 1/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Fugang Duan <B38611@freescale.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Jean Delvare <jdelvare@suse.de>, Philippe Reynes <tremyfr@yahoo.fr>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>
Date: Thu, 25 Sep 2014 22:27:57 +0300
In-Reply-To: <54243533.7080809@mm-sol.com>
References: <1411563415-11933-1-git-send-email-svarbanov@mm-sol.com>
	  <1411563415-11933-2-git-send-email-svarbanov@mm-sol.com>
	 <1411649225.18580.134.camel@iivanov-dev> <54243533.7080809@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 18:30 +0300, Stanimir Varbanov wrote:
> Hi Ivan,
> 
> On 09/25/2014 03:47 PM, Ivan T. Ivanov wrote:
> > 
> > Hi Stan, few comment bellow.
> > 
> > On Wed, 2014-09-24 at 15:56 +0300, Stanimir Varbanov wrote:
> >> The voltage ADC is peripheral of Qualcomm SPMI PMIC chips. It has
> >> 15bits resolution and register space inside PMIC accessible across
> >> SPMI bus.
> >>
> >> The vadc driver registers itself through IIO interface.
> >>
> >> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> >> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> >> ---
> >>  drivers/iio/adc/Kconfig                       |   10 +
> >>  drivers/iio/adc/Makefile                      |    1 +
> >>  drivers/iio/adc/qcom-spmi-vadc.c              | 1029 +++++++++++++++++++++++++
> >>  include/dt-bindings/iio/qcom,spmi-pmic-vadc.h |  119 +++
> >>  4 files changed, 1159 insertions(+), 0 deletions(-)
> >>  create mode 100644 drivers/iio/adc/qcom-spmi-vadc.c
> >>  create mode 100644 include/dt-bindings/iio/qcom,spmi-pmic-vadc.h
> >>
> >> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> >> index 11b048a..ec48360 100644
> >> --- a/drivers/iio/adc/Kconfig
> >> +++ b/drivers/iio/adc/Kconfig
> >> @@ -206,6 +206,16 @@ config NAU7802
> >>  	  To compile this driver as a module, choose M here: the
> >>  	  module will be called nau7802.
> >>  
> >> +config QCOM_SPMI_VADC
> >> +	tristate "Qualcomm SPMI PMIC voltage ADC"
> >> +	depends on SPMI
> > 
> > + select REGMAP_SPMI
> 
> I'd suggest MFD_SPMI_PMIC symbol of the parent driver instead? The
> parent MFD PMIC driver already selects REGMAP_SPMI and depends on SPMI.


+1 for depends on MFD_SPMI_PMIC.

> 
> > 
> > <snip>
> > 
> >> +
> >> +static int vadc_read(struct vadc_priv *vadc, u16 offset, u8 *data)
> >> +{
> >> +	return regmap_bulk_read(vadc->regmap, vadc->base + offset, data, 1);
> > 
> > just regmap_read() ?
> 
> No, regmap_read() expects unsigned int *val as an argument hence I will
> need temporary variable. I had a comment to rework this on the first
> version of the patchset.

Oops, So I should expect the same comment on my IADC driver :-)

> 
> > 
> >> +}
> >> +
> > 
> > General comment, most of the dev_dbg looks like legitimate dev_err's to me.
> 
> I've decided to not flood console with messages. If someone wants to
> debug why the driver doesn't probed he can define DEBUG.

Ok, is up to you.

Regards,
Ivan


