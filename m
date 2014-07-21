Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaGUQPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:15:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbaGUQPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:15:16 -0400
Date: Mon, 21 Jul 2014 18:15:07 +0200
From: Jean Delvare <jdelvare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sjur Brandeland <sjur.brandeland@stericsson.com>
Subject: Run-time dependencies for STE Modem remoteproc driver
Message-ID: <20140721181507.5a6d3b2c@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While other remoteproc drivers have proper platform dependencies set
(OMAP_REMOTEPROC depends on ARCH_OMAP4 || SOC_OMAP5, DA8XX_REMOTEPROC
depends on ARCH_DAVINCI_DA8XX), STE_MODEM_RPROC has no such
dependencies. So the driver is presented on all architectures and can
be enabled even on platforms where it makes no sense.

Could we please add run-time dependencies so that the driver can only
be selected where it makes sense? We can always add || COMPILE_TEST to
allow build-testing everywhere.

This brings the question: on which architectures / platforms is the STE
Modem remoteproc driver needed?

Thanks,
-- 
Jean Delvare
SUSE L3 Support
