Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab3GJUFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:05:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab3GJUFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:05:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: oliver+list@schinagl.nl, linux@roeck-us.net, khali@linux-fr.org
Subject: Driver core and sysfs changes for attribute groups
Date: Wed, 10 Jul 2013 13:05:08 -0700
Message-Id: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Guenter and Oliver have been pointing out a few limitations of the
driver core's ability to create files properly (i.e. in a way that
doesn't race with userspace.)  The driver core allows this, but it
doesn't export that ability to drivers very easily, and for binary
files, not at all.

So here's a set of 6 patches that I'll be queueing up to go to Linus in
time for 3.11 so that people can start using them in their driver
subsystems.  It adds some new macros to make using attributes and
attribute groups easier, adds binary file capabilities to attribute
groups, and finally, lets subsystems (like platform drivers) set a
attribute group for when their device is created.

If anyone has any problems with these patches, please let me know.

Guenter, I've tweaked your original patch a bit, changing the name of
the function and putting the kernel doc comments in the correct place so
the build doesn't complain about it.

I also have a set of follow-on patches, about 50+ big so far, that goes
through the kernel and converts different drivers and subsystems to
properly use attribute groups, instead of open-coding binary files and
attributes.  Those patches will be sent out later, and will be for 3.12
as they aren't needed at the moment, this infrastructure changes are
needed first.

thanks,

greg k-h

