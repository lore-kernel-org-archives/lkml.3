Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaGAFrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 01:47:17 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4546 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaGAFrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 01:47:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 30 Jun 2014 22:40:46 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 0/3] gpio: move interfaces into their own files
Date: Tue, 1 Jul 2014 14:45:13 +0900
Message-ID: <1404193516-4384-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I was thinking of doing this since a while already but the recent discussion on
shared GPIOs made me think I should push this to you and see what you think.

Right now we have 3 different interfaces for GPIO:
- The core gpiod interface
- The legacy integer interface, which mostly relies on gpiod
- The sysfs interface, which relies on gpiod but should probably rely on the
  integer interface instead

This series separates the code for the interfaces into their own source file
and shares what needs to be through the private gpiolib.h header. Label support
is made mandatory in order to reduce the amount of things added into gpiolib.h.

Separating the code should make the various interfaces easier to grasp, and
will make it easier to implement interface-specific features. It also points
out some direct usages of descriptors/gpiolib core functions that should be
gotten rid of in order to make these real "consumers" of the gpiod interface.

This series has been tested and I'm fine with it being merged now if you agree
with the idea. It would probably be preferable from a cosmetic point of view to
first turn fix the extra consumers and then separate them so less things end up
being exported in gpiolib.h, but moving things first has the advantage of
clearly highlighting what needs to be done and spares us some rebasing hassle.

Alexandre Courbot (3):
  gpio: always compile label support
  gpio: move sysfs support to its own file
  gpio: move integer GPIO support to its own file

 drivers/gpio/Makefile         |    2 +
 drivers/gpio/gpiolib-legacy.c |  112 +++++
 drivers/gpio/gpiolib-sysfs.c  |  829 ++++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c        | 1043 +----------------------------------------
 drivers/gpio/gpiolib.h        |   91 ++++
 5 files changed, 1040 insertions(+), 1037 deletions(-)
 create mode 100644 drivers/gpio/gpiolib-legacy.c
 create mode 100644 drivers/gpio/gpiolib-sysfs.c

-- 
2.0.0

