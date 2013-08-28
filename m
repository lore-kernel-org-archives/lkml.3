Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3H1R5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:57:21 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58811 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3H1R5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:57:20 -0400
Date: Wed, 28 Aug 2013 10:57:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Missing removal of sysfs attributes in gpiolib
Message-ID: <20130828175717.GA7493@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that gpiolib does not explicitly remove the sysfs attributes it
created when exporting a gpio pin when the pin is unexported, ie when the
associated device is removed.

Are those attributes auto-removed when device_unregister() is called ?

Sorry if this is a dumb question - I have not noticed this anywhere else,
and I don't seem to be able to find the code actually performing auto-removal
of manually created attributes, so I wonder if this is a bug or intentional.

Thanks,
Guenter
