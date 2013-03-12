Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab3CLSmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:42:04 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34179 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab3CLSmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:42:03 -0400
X-IronPort-AV: E=Sophos;i="4.84,832,1355126400"; 
   d="scan'208";a="28850327"
From: David Brown <davidb@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: [PATCH v2 0/11] Qualcomm SSBI bus driver
Date: Tue, 12 Mar 2013 11:41:45 -0700
Message-Id: <1363113716-25897-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series adds the Qualcomm SSBI bus driver.  The original
driver was developed as part of Android.  Kenneth Heitke updated this,
and sent it out a while back.  This series updates this driver to use
DeviceTree, and fixes a few things that have changed since it was
originally sent out.

In addition, the 11th patch, the RFC, is a small test driver that reads
the version register off of the pm8058 device typically connected to
an MSM8660 or MSM8960.  This is primarily useful to anyone wanting to
work on these pmic drivers.

Updates to the PMIC drivers themselves to use this driver to come.

Patch version:
  v2: Updates from mailing list feedback:
     - Use EXPORT_SYMBOL_GPL
     - Proper fix for driver remove section mismatch
     - Allow compilation as a module
     - Remove extraneous dev_err() messages
     - Comment use of busywait loop
     - Update MAINTAINERS file
