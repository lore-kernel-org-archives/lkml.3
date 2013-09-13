Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3IMSdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:33:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3IMSdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:33:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/13] hv: clean up dev_attr usage
Date: Fri, 13 Sep 2013 11:32:48 -0700
Message-Id: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a set of 13 patches to get rid of the dev_attrs use in the hv bus
code, as it will be going away soon.  It's _way_ bigger than all other
conversions I've had to do so far in the kernel, as you were using a
"multiplexor" function for all of these files.

So, I've broken it up into individual show/store sysfs functions, and
cleaned up a bunch of debug structures that aren't needed and shouldn't
be exported to the rest of the kernel.

I've also fixed up some void * usage in the hv core, in patch 07, to
make things simpler and not so "magic" when dealing with these pages.
If you could review that one closely to ensure I didn't mess anything
up, I would appreciate it.

Also, are all of these files really needed for sysfs?  They seem to be
all debugging stuff, shouldn't they go into debugfs if you really
need/use them anymore?

KY, could you test these out?  I don't have access to a hv system at the
moment.  I'll wait for your ack before applying them to any of my trees.

thanks,

greg k-h

