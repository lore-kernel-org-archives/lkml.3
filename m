Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3LARcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 12:32:13 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:63074 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035Ab3LARcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 12:32:07 -0500
Message-ID: <1385919125.7199.17.camel@x41.thuisdomein>
Subject: firmware: new "platform microcode" warning in v3.13-rc1+
From: Paul Bolle <pebolle@tiscali.nl>
To: Neil Horman <nhorman@tuxdriver.com>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 01 Dec 2013 18:32:05 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Dec 2013 17:32:05.0979 (UTC) FILETIME=[41287AB0:01CEEEBB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) Booting v3.13-rc1 and v3.13-rc2 triggers two new warnings on an
(outdated, I'm afraid) ThinkPad X41:
    [...]
    <6>[   16.746119] libipw: 802.11 data/management/control stack, git-1.1.13
    <6>[   16.746125] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
    <4>[   16.761998] platform microcode: Direct firmware load failed with error -2
    <4>[   16.762022] platform microcode: Falling back to user helper
    <6>[   16.787885] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
    <6>[   16.787895] ipw2200: Copyright(c) 2003-2006 Intel Corporation
    <6>[   16.788741] ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
    [...]

(I've added the surrounding lines because they suggest this is about the
firmware for that wireless device. Please note that this device appears
to work no worse than it did under v3.12.)

1) These warnings can be traced back to commit 3e358ac2bb5b ("firmware:
Be a bit more verbose about direct firmware loading failure").

2) Is there something I'm supposed to do to silence these warnings? If
so, what would that be? If not, can these messages perhaps be downgraded
to dev_info or dev_notice?


Paul Bolle

