Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3EVMr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:47:59 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:58592 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3EVMr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:47:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, linus.walleij@linaro.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: [RC FIXES] Fix broken MMC devices on Snowball
Date: Wed, 22 May 2013 13:47:31 +0100
Message-Id: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly introduced ab8500 external regulator driver causes an
unexpected quirk when used with the Snowball low-cost development
board. When the 3 ab8500 external regulators are registered, the
ones which can be freed, are. Unfortunately, on Snowball one of
them is connected to the MMC power line. Once freed, this turns
off the MMC device. External regulators are not used on Snowball,
so it's pointless registering them in the first place.

These two patches ensure external regulators aren't registered 
on Snowball or any other platforms which do not require them.

