Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaLEKib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:38:31 -0500
Received: from ispman.iskranet.ru ([62.213.33.10]:50856 "EHLO
	ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaLEKi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:38:28 -0500
From: Arseny Solokha <asolokha@kb.kras.ru>
To: Claudiu Manoil <claudiu.manoil@freescale.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arseny Solokha <asolokha@kb.kras.ru>
Subject: [PATCH 0/2] DMA API usage fixes in gianfar
Date: Fri,  5 Dec 2014 17:37:52 +0700
Message-Id: <1417775874-17775-1-git-send-email-asolokha@kb.kras.ru>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This patch set fixes DMA API usage issues in gianfar ethernet driver
reported by the kernel w/ DMA API debug enabled.

There were even reports that the kernel sometimes oopsed in the past
because of kernel paging request handling failures, though it was likely
observed on some ancient versions. And while I personally doesn't have
any strong evidence of this, there's no reason to let these possible
failures live any longer.

Arseny Solokha (2):
  gianfar: handle map error in gfar_new_rxbdp()
  gianfar: handle map error in gfar_start_xmit()

 drivers/net/ethernet/freescale/gianfar.c | 49 ++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 8 deletions(-)

-- 
Regards,
Arseny Solokha.
