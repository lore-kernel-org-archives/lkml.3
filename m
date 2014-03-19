Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbaCSVAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:00:12 -0400
Received: from mail-ob0-f201.google.com ([209.85.214.201]:40486 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbaCSVAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:00:07 -0400
From: Ben Chan <benchan@chromium.org>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Oliver Neukum <oliver@neukum.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Suarez <gsuarez@smithmicro.com>
Subject: [PATCH net-next v4 0/2] adjust MTU as indicated by MBIM extended functional descriptor
Date: Wed, 19 Mar 2014 14:00:04 -0700
Message-Id: <1395262806-19237-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MBIM extended functional descriptor, defined in "Universal Serial Bus
Communications Class Subclass Specification for Mobile Broadband Interface
Model, Revision 1.0, Errata-1" by USB-IF, indicates the operator preferred MTU
value via a wMTU field.

This patch set ensures that the initial MTU value set by cdc_ncm on a MBIM net
device does not exceed the wMTU value, provided the MBIM device exposes a MBIM
extended functional descriptor.

* Changelog
v2: Fixed a le16_to_cpu conversion issue in patch 2/2 pointed out by
    Bjørn Mork <bjorn@mork.no>
v3: No code changes. Resubmitted to include patch 1/2 as suggested by
    David Miller <davem@davemloft.net>
v4: No code changes. Resubmitted as suggested by David Miller:
    - Added a summary of the patch set
    - Carried the ACK from Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    - Added a specified the tree (net-next) to apply the patch set to

Ben Chan (2):
  USB: cdc: add MBIM extended functional descriptor structure
  net: cdc_ncm: respect operator preferred MTU reported by MBIM

 drivers/net/usb/cdc_ncm.c    | 17 +++++++++++++++++
 include/linux/usb/cdc_ncm.h  |  1 +
 include/uapi/linux/usb/cdc.h | 12 ++++++++++++
 3 files changed, 30 insertions(+)

-- 
1.9.0.279.gdc9e3eb

