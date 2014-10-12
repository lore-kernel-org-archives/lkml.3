Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaJLLkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:40:09 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:65249 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaJLLkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:40:07 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Brett Rudley <brudley@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        linville@tuxdriver.com
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Hante Meuleman <meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Daniel Kim <dekim@broadcom.com>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] brcmfmac: dhd_sdio.c:  Cleaning up missing null-terminate in conjunction with strncpy 
Date: Sun, 12 Oct 2014 13:42:13 +0200
Message-Id: <1413114134-18044-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now when I did the patch again I just want to ensure that this is not any other errors.

Although strncpy use before was wrong, it did filled the remaining part of the string with null
characters. This is not something that is needed?


And a part that is not obvious right, so check.
When brcmf_firmware_path[0] == '\0'   we do not want to do like.

if (brcmf_firmware_path[0] != '\0') {
...
} else {
  sdiodev->fw_name[0] = '\0';
  sdiodev->nvram_name[0] = '\0';
}


Kind regards
Rickard Strandqvist


Rickard Strandqvist (1):
  net: wireless: brcm80211: brcmfmac: dhd_sdio.c:  Cleaning up missing null-terminate in conjunction with
    strncpy

 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   25 ++++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

-- 
1.7.10.4

