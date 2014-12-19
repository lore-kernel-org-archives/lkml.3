Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaLSJzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:55:48 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58085 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaLSJzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:55:46 -0500
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: Peter.Chen@freescale.com
Cc: stefan@agner.ch, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH 0/3] usb: chipidea: add one errata for revision 2.40a
Date: Fri, 19 Dec 2014 15:25:26 +0530
Message-Id: <cover.1418981438.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first two patches add identification register API's. These can
be used to get controller's revision. 

The third patch implements an errata for revision 2.40a. Not sure
which other SOCs implement this version of the Chipidea core but
this fixes the usb client issue observed on Vybrids. The patch was
tested on a Toradex Colibri VF61 module with the 3.18 kernel. iperf
tests ran for three hours plus, with these patches applied have found
the USB client connection to be now reliable.

This patchset is based off on Shawn Guo's for-next branch
https://git.kernel.org/cgit/linux/kernel/git/shawnguo/linux.git/tree/?h=for-next

The credit for the patches and fix goes to Matthieu Castet and Peter Chen.
First two patches are by Peter Chen and the third patch which fixed the
bug we observed was reported by Matthieu Castet.

The discussion of the problem and the relevant testing details can be found
at this link: http://www.spinics.net/lists/linux-usb/msg118544.html

The first version of this patchset originally send by Peter Chen can be
found at this link: http://www.spinics.net/lists/linux-usb/msg118753.html

Comments for review are welcome :).
Note: I am going on a vacation so will not be able to reply or do any further
tests till Monday. Will attend and take care of any comments/requests for 
further changes/testing from Tuesday. Apologize for the delay in advance.

Sanchayan Maity (3):
  usb: chipidea: Add identification registers access APIs
  usb: chipidea: Add chipidea revision information
  usb: chipidea: Add errata for revision 2.40a

 drivers/usb/chipidea/bits.h |   10 ++++++++
 drivers/usb/chipidea/ci.h   |   53 +++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/chipidea/core.c |   23 +++++++++++++++++--
 drivers/usb/chipidea/udc.c  |   20 ++++++++++++++++
 4 files changed, 104 insertions(+), 2 deletions(-)

-- 
1.7.9.5

