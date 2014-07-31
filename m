Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaGaIVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:21:14 -0400
Received: from yes.iam.tj ([109.74.197.121]:37965 "EHLO iam.tj"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932073AbaGaIVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:21:11 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2014 04:21:11 EDT
Message-ID: <53D9FADA.6020304@iam.tj>
Date: Thu, 31 Jul 2014 09:14:18 +0100
From: TJ <linux@iam.tj>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Regression: pci=realloc fails to modify bridge windows, causing devices
 to fail BAR allocation
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See https://bugzilla.kernel.org/show_bug.cgi?id=81431

Summary:

Up until v3.15.7 booting with "pci=realloc,use_crs" successfully modifies the PCI bridge windows to allow an external ExpressCard <> ViDock4 + Nvidia Quadro NVS420 with its 2 GPUs to be configured.

With v3.16rc6 and rc7 it fails to do this, leaving the NVS420 inoperable.
