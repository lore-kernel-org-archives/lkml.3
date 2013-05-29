Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172Ab3E2I1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:27:49 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:35067 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965084Ab3E2I1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:27:47 -0400
Date: Wed, 29 May 2013 10:27:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: What is listed in /sys/module?
Message-ID: <20130529102735.3ce72ecc@endymion.delvare>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Rusty,

I have a question related to /sys/module and can't seem to find the
answer by myself so I hope you can explain.

I noticed that /sys/module contains more than /proc/modules. At first I
thought that any potentially modular piece of code would show up
in /sys/module, so /sys/module would include both actual modules and
"built-in modules".

However I then noticed that some built-in modules do _not_ show up
in /sys/module. For example, I have USB and I2C core support built into
my 3.9.4 kernel, /sys/module/usbcore exists but /sys/module/i2c_core
does not. CONFIG_SENSORS_W83795=y did not give me /sys/module/w83795
either.

So my questions are:
1* What exactly is supposed to show up in /sys/module?
   Documentation/ABI/stable/sysfs-module says:

	/sys/module/MODULENAME
		The name of the module that is in the kernel.  This
		module name will show up either if the module is built
		directly into the kernel, or if it is loaded as a
		dynamic module.

  But my tests above contradict this statement.

And more precisely:
2* For what reason do some built-in modules show up in /sys/module and
   others do not? Is it a bug?

Thanks,
-- 
Jean Delvare
