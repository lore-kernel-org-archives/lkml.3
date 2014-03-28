Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaC1QIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:08:18 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33835 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaC1QIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:08:15 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, benh@kernel.crashing.org,
        rob.herring@linaro.org
Subject: [RFC 0/5] of: Automatic console registration cleanups
Date: Fri, 28 Mar 2014 09:08:00 -0700
Message-Id: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a series that I've been playing with over the last few days to
clean up the selection of default console devices when using the device
tree. The device tree defines a way of specifying the console by using a
"stdout-path" property in the /chosen node, but very few drivers
actually attempt to use that data, and so for most platforms there needs
to be a "console=" line in the command line if a serial port is intended
to be used as the console.

With this series, if there is a /chosen/stdout-path property, and if
that property points to a serial port node, then when the serial driver
registers the port, the core uart_add_one_port() function will notice
and if no console= argument was provided then add it as a preferred
console.

I've not tested this very extensively yet, but I want to get some
feedback before I go further.

The one downside with this approach is that it doesn't do anything for
early console setup. That still needs to be added on a per-driver basis,
but at least it shouldn't conflict with this approach.

