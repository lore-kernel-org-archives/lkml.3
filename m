Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab3CXGk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 02:40:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:36103 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab3CXGkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 02:40:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,900,1355126400"; 
   d="scan'208";a="275117792"
Date: Sun, 24 Mar 2013 08:44:58 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Corey Richardson <corey@octayn.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: clk: x86: build failure
Message-ID: <20130324064458.GF21804@intel.com>
References: <CA++BO6Qz90ZY4udNYYPJLMhUi1Q3kwrW16G6j_-tf_bfPfqU5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA++BO6Qz90ZY4udNYYPJLMhUi1Q3kwrW16G6j_-tf_bfPfqU5A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 01:57:01PM -0400, Corey Richardson wrote:
> With the attached config, I get the following build failure:
> 
>   LD      init/built-in.o
> drivers/built-in.o:clk-lpt.c:function v4l2_device_unregister: error:
> undefined reference to 'i2c_unregister_device'

I get following with your config:

LD      init/built-in.o
drivers/built-in.o: In function `v4l2_device_unregister':
(.text+0x1186cb): undefined reference to `i2c_unregister_device'
make: *** [vmlinux] Error 1

and it looks like it wants to build in videodev.o (which provides
v4l2_device_unregister()):

CONFIG_VIDEO_DEV=y

This function calls i2c_unregister_device() if IS_ENABLED(CONFIG_I2C) but
i2c support is compiled as a module:

CONFIG_I2C=m

which explains the link error.

However, this has nothing to do with clk-lpt.c or anything related to clock
framework as far as I can tell.
