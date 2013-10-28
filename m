Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab3J1RFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:05:37 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:34657 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab3J1RFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:05:36 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/2] misc/eeprom: avoid infinite write() loop over sysfs interface
Date: Mon, 28 Oct 2013 19:05:14 +0200
Message-ID: <1382979916-3494-1-git-send-email-vladimir_zapolskiy@mentor.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 28 Oct 2013 17:05:35.0637 (UTC) FILETIME=[EB320C50:01CED3FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes a problem of infinite zero byte write() without
an error status, if there is an attempt to write a file bigger than
EEPROM size over sysfs interface.

Vladimir Zapolskiy (2):
  misc/at24: avoid infinite loop on write()
  misc/93xx46: avoid infinite loop on write()

 drivers/misc/eeprom/at24.c          |    3 +++
 drivers/misc/eeprom/eeprom_93xx46.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
1.7.10.4

