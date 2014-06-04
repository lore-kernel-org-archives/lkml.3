Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbaFDJKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:10:07 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:7781 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbaFDJJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:09:59 -0400
X-IronPort-AV: E=Sophos;i="4.98,972,1392159600"; 
   d="scan'208";a="65385487"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        iss_storagedev@hp.com, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, adi-buildroot-devel@lists.sourceforge.net
Subject: [PATCH 0/10] use safer test on the result of find_first_zero_bit
Date: Wed,  4 Jun 2014 11:07:50 +0200
Message-Id: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
return a larger number than the maximum position argument if that position
is not a multiple of BITS_PER_LONG.

