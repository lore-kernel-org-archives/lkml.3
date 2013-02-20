Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122Ab3BTJHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:07:42 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:62941 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab3BTJHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:07:34 -0500
Date: Wed, 20 Feb 2013 10:07:23 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeong, Daniel" <Daniel.Jeong@ti.com>
Subject: Re: [PATCH 1/3] leds: move LED trigger drivers into new subdirectory
Message-ID: <20130220090723.GA8049@balto.lan>
References: <A874F61F95741C4A9BA573A70FE3998F7927366E@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F7927366E@DQHE02.ent.ti.com>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kim,

On Wed, Feb 20, 2013 at 08:36:01AM +0000, Kim, Milo wrote:
> For better driver management, new subdirectory, 'trigger' is created.
> All LED trigger drivers are moved into this directory.
> 
> Internal header, 'leds.h' is included in each LED trigger drivers.
> Fix the location of header file, "leds.h" -> "../leds.h" in driver files.
> One exception is here, 'ledtrig-timer.c'.
> There is no need to include 'leds.h'. so '#include "leds.h"' line was removed.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/Kconfig                      |  101 +-----------
>  drivers/leds/Makefile                     |   10 +-
>  drivers/leds/ledtrig-backlight.c          |  166 -------------------
>  drivers/leds/ledtrig-cpu.c                |  142 ----------------
>  drivers/leds/ledtrig-default-on.c         |   45 -----
>  drivers/leds/ledtrig-gpio.c               |  253 -----------------------------
>  drivers/leds/ledtrig-heartbeat.c          |  161 ------------------
>  drivers/leds/ledtrig-ide-disk.c           |   47 ------
>  drivers/leds/ledtrig-oneshot.c            |  204 -----------------------
>  drivers/leds/ledtrig-timer.c              |  131 ---------------
>  drivers/leds/ledtrig-transient.c          |  237 ---------------------------
>  drivers/leds/trigger/Kconfig              |  103 ++++++++++++
>  drivers/leds/trigger/Makefile             |    9 +
>  drivers/leds/trigger/ledtrig-backlight.c  |  166 +++++++++++++++++++
>  drivers/leds/trigger/ledtrig-cpu.c        |  142 ++++++++++++++++
>  drivers/leds/trigger/ledtrig-default-on.c |   45 +++++
>  drivers/leds/trigger/ledtrig-gpio.c       |  253 +++++++++++++++++++++++++++++
>  drivers/leds/trigger/ledtrig-heartbeat.c  |  161 ++++++++++++++++++
>  drivers/leds/trigger/ledtrig-ide-disk.c   |   47 ++++++
>  drivers/leds/trigger/ledtrig-oneshot.c    |  204 +++++++++++++++++++++++
>  drivers/leds/trigger/ledtrig-timer.c      |  130 +++++++++++++++
>  drivers/leds/trigger/ledtrig-transient.c  |  237 +++++++++++++++++++++++++++
>  22 files changed, 1499 insertions(+), 1495 deletions(-)
>  delete mode 100644 drivers/leds/ledtrig-backlight.c
>  delete mode 100644 drivers/leds/ledtrig-cpu.c
>  delete mode 100644 drivers/leds/ledtrig-default-on.c
>  delete mode 100644 drivers/leds/ledtrig-gpio.c
>  delete mode 100644 drivers/leds/ledtrig-heartbeat.c
>  delete mode 100644 drivers/leds/ledtrig-ide-disk.c
>  delete mode 100644 drivers/leds/ledtrig-oneshot.c
>  delete mode 100644 drivers/leds/ledtrig-timer.c
>  delete mode 100644 drivers/leds/ledtrig-transient.c
>  create mode 100644 drivers/leds/trigger/Kconfig
>  create mode 100644 drivers/leds/trigger/Makefile
>  create mode 100644 drivers/leds/trigger/ledtrig-backlight.c
>  create mode 100644 drivers/leds/trigger/ledtrig-cpu.c
>  create mode 100644 drivers/leds/trigger/ledtrig-default-on.c
>  create mode 100644 drivers/leds/trigger/ledtrig-gpio.c
>  create mode 100644 drivers/leds/trigger/ledtrig-heartbeat.c
>  create mode 100644 drivers/leds/trigger/ledtrig-ide-disk.c
>  create mode 100644 drivers/leds/trigger/ledtrig-oneshot.c
>  create mode 100644 drivers/leds/trigger/ledtrig-timer.c
>  create mode 100644 drivers/leds/trigger/ledtrig-transient.c

For this kind of patches you should really use the "-M" flag of "git
format-patch" to activate rename detection.  The patch becomes much more
readable.  For example, the diffstat for this one using -M is:

 drivers/leds/Kconfig                            | 101 +----------------------
 drivers/leds/Makefile                           |  10 +--
 drivers/leds/trigger/Kconfig                    | 103 ++++++++++++++++++++++++
 drivers/leds/trigger/Makefile                   |   9 +++
 drivers/leds/{ => trigger}/ledtrig-backlight.c  |   2 +-
 drivers/leds/{ => trigger}/ledtrig-cpu.c        |   2 +-
 drivers/leds/{ => trigger}/ledtrig-default-on.c |   2 +-
 drivers/leds/{ => trigger}/ledtrig-gpio.c       |   2 +-
 drivers/leds/{ => trigger}/ledtrig-heartbeat.c  |   2 +-
 drivers/leds/{ => trigger}/ledtrig-ide-disk.c   |   0
 drivers/leds/{ => trigger}/ledtrig-oneshot.c    |   2 +-
 drivers/leds/{ => trigger}/ledtrig-timer.c      |   1 -
 drivers/leds/{ => trigger}/ledtrig-transient.c  |   2 +-
 13 files changed, 121 insertions(+), 117 deletions(-)
 create mode 100644 drivers/leds/trigger/Kconfig
 create mode 100644 drivers/leds/trigger/Makefile
 rename drivers/leds/{ => trigger}/ledtrig-backlight.c (99%)
 rename drivers/leds/{ => trigger}/ledtrig-cpu.c (99%)
 rename drivers/leds/{ => trigger}/ledtrig-default-on.c (98%)
 rename drivers/leds/{ => trigger}/ledtrig-gpio.c (99%)
 rename drivers/leds/{ => trigger}/ledtrig-heartbeat.c (99%)
 rename drivers/leds/{ => trigger}/ledtrig-ide-disk.c (100%)
 rename drivers/leds/{ => trigger}/ledtrig-oneshot.c (99%)
 rename drivers/leds/{ => trigger}/ledtrig-timer.c (99%)
 rename drivers/leds/{ => trigger}/ledtrig-transient.c (99%)

Fabio

-- 
Fabio Baltieri
