Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3CONBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:01:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50009 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab3CONBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:01:09 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 00/50] staging: omap-thermal: several code refactoring
Date: Fri, 15 Mar 2013 08:59:48 -0400
Message-ID: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

Here is a series of patches improving the way the omap-thermal driver
is written. There is a mix of added documentation, with functions rewrites
and cleanups regarding coding style. I am also adding myself as maintainer
of this driver.

Next I will be still improving the code in this way, but also working
on the policy readiness and  testing on other devices. I will probably
rename the driver also to something that reflect the support to AMxx devices
as well.

Hopefully, it should be soon ready for moving to drivers/thermal/.

All these are based on your staging/staging-next branch.

For those interested in testing and trying the driver, these patches are
also available, as usual, here:
git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/omap/omap-thermal-optimizations
https://git.gitorious.org/thermal-framework/thermal-framework.git thermal_work/omap/omap-thermal-optimizations

For lo guys, I will appreciate your testing results on other devices.

Cheers,


Eduardo Valentin (50):
  staging: omap-thermal: use BIT() macro
  staging: omap-thermal: remove unused _SHIFT macros
  staging: omap-thermal: create header for register, bitfields and
    definitions
  staging: omap-thermal: update documentation of omap-bandgap.h
  staging: omap-thermal: style cleanup on omap-bandgap.c
  staging: omap-thermal: fix error checking
  staging: omap-thermal: introduce RMW_BITS macro
  staging: omap-thermal: add documentation for register access
    functions
  staging: omap-thermal: make a omap_bandgap_power with only one exit
    point
  staging: omap-thermal: add documentation for omap_bandgap_power
  staging: omap-thermal: add documentation for omap_bandgap_read_temp
  staging: omap-thermal: rename talert handler
  staging: omap-thermal: update documentation for talert irq handler
  staging: omap-thermal: update tshut IRQ handler documentation
  staging: omap-thermal: remove duplicated code
  staging: omap-thermal: read status only once inside alert IRQ
  staging: omap-thermal: add a section of register manipulation
  staging: omap-thermal: section of basic helpers
  staging: omap-thermal: IRQ handler section
  staging: omap-thermal: ADC section
  staging: omap-thermal: name adc_to_temp_conversion in a better way
  staging: omap-thermal: rewrite omap_bandgap_adc_to_mcelsius on kernel
    coding style
  staging: omap-thermal: add documentation for
    omap_bandgap_adc_to_mcelsius
  staging: omap-thermal: name temp_to_adc_conversion in a better way
  staging: omap-thermal: rewrite omap_bandgap_mcelsius_to_adc on kernel
    coding style
  staging: omap-thermal: move conv table limits out of sensor data
  staging: omap-thermal: add documentation for
    omap_bandgap_mcelsius_to_adc
  staging: omap-thermal: rename add_hyst to omap_bandgap_add_hyst
  staging: omap-thermal: document omap_bandgap_add_hyst function
  staging: omap-thermal: threshold manipulation section
  staging: omap-thermal: refactor temp_sensor_unmask_interrupts
  staging: omap-thermal: update omap_bandgap_unmask_interrupts
    documentation
  staging: omap-thermal: refactor APIs handling threshold values
  staging: omap-thermal: device initialization section
  staging: omap-thermal: section of device driver callbacks
  staging: omap-thermal: rename enable_continuous_mode
  staging: omap-thermal: update omap_bandgap_set_continous_mode
    documentation
  staging: omap-thermal: document omap_bandgap_force_single_read
  staging: omap-thermal: document omap_bandgap_update_alert_threshold
    function
  staging: omap-thermal: document _omap_bandgap_write_threshold
    function
  staging: omap-thermal: document _omap_bandgap_read_threshold function
  staging: omap-thermal: document omap_bandgap_tshut_init function
  staging: omap-thermal: document omap_bandgap_alert_init function
  staging: omap-thermal: document omap_bandgap_build function
  staging: omap-thermal: change Kconfig dependency method
  staging: Add a MAINTAINERS entry for TI bandgap and thermal driver
  staging: omap-thermal: switch mutex to spinlock inside omap-bandgap
  staging: omap-thermal: remove TODO entry suggesting regmap usage
  staging: omap-thermal: remove TODO entry for exposed APIs
  staging: omap-thermal: add documentation for omap_bandgap_validate

 MAINTAINERS                                        |    6 +
 drivers/staging/omap-thermal/Kconfig               |    2 +-
 drivers/staging/omap-thermal/TODO                  |    4 -
 drivers/staging/omap-thermal/omap-bandgap.c        |  793 +++++++++++---------
 drivers/staging/omap-thermal/omap-bandgap.h        |  498 +++++--------
 drivers/staging/omap-thermal/omap-thermal-common.c |    4 +-
 drivers/staging/omap-thermal/omap4-thermal-data.c  |   11 +-
 drivers/staging/omap-thermal/omap4xxx-bandgap.h    |  175 +++++
 drivers/staging/omap-thermal/omap5-thermal-data.c  |    9 +-
 drivers/staging/omap-thermal/omap5xxx-bandgap.h    |  199 +++++
 10 files changed, 1030 insertions(+), 671 deletions(-)
 create mode 100644 drivers/staging/omap-thermal/omap4xxx-bandgap.h
 create mode 100644 drivers/staging/omap-thermal/omap5xxx-bandgap.h

-- 
1.7.7.1.488.ge8e1c

