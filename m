Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbaFLQ64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:58:56 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46115 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaFLQ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:58:54 -0400
From: Jassi Brar <jaswinder.singh@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, mporter@linaro.org, patches@linaro.org,
        bjorn@kryo.se, ashwin.chaugule@linaro.org, gregkh@linuxfoundation.org,
        s-anna@ti.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        pawel.moll@arm.com, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, arnd@arndb.de, joshc@codeaurora.org,
        linus.walleij@linaro.org, galak@codeaurora.org, ks.giri@samsung.com
Subject: [PATCHv7 0/5] Common Mailbox Framework
Date: Thu, 12 Jun 2014 22:28:37 +0530
Message-Id: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  Here is the next revision of Mailbox framwork.

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
Jassi
