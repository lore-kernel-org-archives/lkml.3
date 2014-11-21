Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbaKUP36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:29:58 -0500
Received: from s250.sam-solutions.net ([217.21.49.219]:47974 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbaKUP3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:29:23 -0500
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
To: <support.opensource@diasemi.com>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] mfd: da9063: Register device with proper irq_base
Date: Fri, 21 Nov 2014 18:29:06 +0300
Message-ID: <1416583748-6622-1-git-send-email-d.lavnikevich@sam-solutions.com>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes rtc-da9063 registration failure caused by
platform_get_irq_byname() returning local irq instead of virtual one.

In first patch version it was supposed to just transform local IRQ to
VIRQ in rtc-da9063 driver but after discussion in [1] it was decided
to register mfd device with proper irq_base instead of performing IRQ
transform. This is done with patch 1.

This way getting VIRQ in da9063-regulator driver become unnecessary
and so it is removed with patch 2.

[1] https://lkml.org/lkml/2014/11/20/242

