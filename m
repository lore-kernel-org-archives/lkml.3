Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaCBInp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 03:43:45 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:45110 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaCBIno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 03:43:44 -0500
MIME-Version: 1.0
From: Yogesh Chaudhari <mr.yogesh@gmail.com>
Date: Sun, 2 Mar 2014 14:13:03 +0530
Message-ID: <CAAOfnZrRGd0Bdg0c0D1015O5f=BC2=hwfZ5WNv=z5bBf5y6TmQ@mail.gmail.com>
Subject: scripts/checkpatch.pl
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I recently ran "scripts/checkpatch.pl" after adding the simplest form
of "hello world" module to the source tree. I used the old "printk"s
in this module and got this warning message:

WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then
pr_debug(...  to printk(KERN_DEBUG ...

It has come to my understanding that the dynamic debugging interface
offered by pr_debug and dev_dbg have obvious advantages to printk and
therefore they are preferred to printk.

Even amongst dev_dbg and pr_debug, we prefer dev_dbg if we have a
struct device to standardize device information output along with our
debug message. It offers escape from the "edit/rebuild/reboot cycle"
and also allows to maintain a neat log through dynamic_debug/control
interface.

I was not clear as to why netdev_dbg would be preferred to dev_dbg and
was given this asnwer on stackoverflow:

http://stackoverflow.com/questions/22077540/order-of-preference-printk-vs-dev-dbg-vs-netdev-dbg

Particularly, in regards to this part:
"netdev_dbg it is not the absolutly prefered print style. It is
prefered if you are working with a netdevice."

If this is the case, then I think the WARNING message should be
modified to mention that [subsystem]_dbg is preferred over dev_dbg. In
case this is correct and I am not missing something, I would like to
propose a patch to modify this script to give appropriate error
message. But in case I am wrong about this I would like
comments/suggestions/explanations before starting anything.

Thanks
Yogesh
