Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaBTJor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:44:47 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.150]:39597 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbaBTJon convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:44:43 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-6.tower-179.messagelabs.com!1392889480!27497706!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [PATCH V1 3/3] REGULATOR: da9052: Add new DA9053 BC chip variant
Thread-Topic: [PATCH V1 3/3] REGULATOR: da9052: Add new DA9053 BC chip
 variant
Thread-Index: AQHPLZDd/hGxmGS8pUuU+YIMScUjT5q8yYCAgAEVx9A=
Date: Thu, 20 Feb 2014 09:44:38 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51BCFD89E0@NB-EX-MBX02.diasemi.com>
References: <201402191637.s1JGb4t9017699@swsrvapps-02.lan>
 <20140219164747.GB2669@sirena.org.uk>
In-Reply-To: <20140219164747.GB2669@sirena.org.uk>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.24.126]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: 19 February 2014 16:48
> To: Opensource [Anthony Olech]
> Cc: Liam Girdwood; Lee Jones; linux-kernel@vger.kernel.org; Samuel Ortiz;
> David Dajun Chen
> Subject: Re: [PATCH V1 3/3] REGULATOR: da9052: Add new DA9053 BC chip
> variant
> On Wed, Feb 19, 2014 at 04:32:47PM +0000, Opensource [Anthony Olech]
> wrote:
> > Add support for a new BC variant of the DA9053 PMIC.
> Acked-by: Mark Brown <broonie@linaro.org>
> > There is one difference between it and the AA, BA and BB.
> Which is...?  :)
Hi Mark,

it is easier to see in the diff -C15 output, that the BC chip does not need
a 'safe read':

--- drivers/mfd/da9052-i2c.c	Thu Feb 20 09:20:43 2014
***************
*** 63,92 ****
--- 63,93 ----
  static int da9052_i2c_fix(struct da9052 *da9052, unsigned char reg)
  {
  	int val;
  
  	switch (da9052->chip_id) {
  	case DA9052:
  	case DA9053_AA:
  	case DA9053_BA:
  	case DA9053_BB:
  		/* A dummy read to a safe register address. */
  	if (!i2c_safe_reg(reg))
  			return regmap_read(da9052->regmap,
  					   DA9052_PARK_REGISTER,
  					   &val);
  		break;
+ 	case DA9053_BC:
  	default:
  		/*
  		 * For other chips parking of I2C register
  		 * to a safe place is not required.
  		 */
  		break;
  	}
  
  	return 0;
  }

  Tony Olech
