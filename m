Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaHAMak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:30:40 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52704 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbaHAMai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:30:38 -0400
From: Jassi Brar <jaswinder.singh@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ks.giri@samsung.com, arnd@arndb.de, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, pawel.moll@arm.com,
        courtney.cavin@sonymobile.com, mporter@linaro.org,
        slapdau@yahoo.com.au, lftan.linux@gmail.com, loic.pallardy@st.com,
        s-anna@ti.com, ashwin.chaugule@linaro.org, bjorn@kryo.se,
        patches@linaro.org, mollie.wu@linaro.org, t.takinishi@jp.fujitsu.com,
        broonie@linaro.org, khilman@linaro.org, lee.jones@linaro.org,
        andy.green@linaro.org, Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv10 0/4] Common Mailbox Framework
Date: Fri,  1 Aug 2014 17:59:54 +0530
Message-Id: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
 Here's v10. Not much different from v9. The code and the generic
bindings looked good enough to relevant gods, but the patchset still
needs some formal loving in the form of Acked-by's.

Changes since v9:
 o Purely cosmetic changes - added headers and used BIT() 

Changes since v8:
 o Nits like spelling corrections and a couple symbol renames
 o Made 'mbox-names' optional in favor of index of mailbox
   specifier in 'mboxes' property. Which results in
     mbox_request_channel(struct mbox_client *cl)
        to
     mbox_request_channel(struct mbox_client *cl, int index)
 o Separate out Documentation and Bindings patches.

Changes since v7:
 o Added documentation and example usage.
 o Merged all patches into one that create api, bindings and
   documentation.

Changes since v6:
 o Separate out generic DT bindings patch.
 o Discard unnecessary aligned attributes.

Changes since v5:
 o Use standard error types instead of special type mbox_result.
 o Constify client struct in request_channel
 o Use reinit_completion instead of init_completion every time.
 o Improve commentary in bindings and code.

Changes since v4:
 o Common DT binding for Controller and Client drivers
    As a result, discard string based channel matching
 o Provide for an atomic 'peek' api, that a client could
    call to trigger the controller driver push data upwards.
 o OMAP and Highbank conversion to new api is left out, which
    can be converted later by the developers.

Changes since v3:
 o Change name of symbols from ipc to mbox
 o Return real types instead of void *
 o Align structures
 o Change some symbol names
        rxcb -> rx_callback
        txcb -> tx_done
 o Added kernel-doc for exported API
 o Dropped the cl_id and use clients pointer for callbacks.
 o Fixed locking of channel pool
 o Return negative error code for unsuccessful ipc_send_message()
 o Module referencing during mailbox assignment to a client.
 o Made error code symbols specific to mailbox.

Thanks
-Jassi

Jassi Brar (3):
  mailbox: Introduce framework for mailbox
  doc: add documentation for mailbox framework
  dt: mailbox: add generic bindings

Suman Anna (1):
  mailbox: rename pl320-ipc specific mailbox.h

 .../devicetree/bindings/mailbox/mailbox.txt        |  36 ++
 Documentation/mailbox.txt                          | 122 ++++++
 MAINTAINERS                                        |   8 +
 arch/arm/mach-highbank/highbank.c                  |   2 +-
 drivers/cpufreq/highbank-cpufreq.c                 |   2 +-
 drivers/mailbox/Makefile                           |   4 +
 drivers/mailbox/mailbox.c                          | 466 +++++++++++++++++++++
 drivers/mailbox/pl320-ipc.c                        |   2 +-
 include/linux/mailbox_client.h                     |  46 ++
 include/linux/mailbox_controller.h                 | 135 ++++++
 include/linux/{mailbox.h => pl320-ipc.h}           |   0
 11 files changed, 820 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mailbox/mailbox.txt
 create mode 100644 Documentation/mailbox.txt
 create mode 100644 drivers/mailbox/mailbox.c
 create mode 100644 include/linux/mailbox_client.h
 create mode 100644 include/linux/mailbox_controller.h
 rename include/linux/{mailbox.h => pl320-ipc.h} (100%)

-- 
1.8.1.2

