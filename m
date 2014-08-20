Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaHTVej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 17:34:39 -0400
Received: from ris.borea.si ([193.77.156.21]:51666 "EHLO ris.borea.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbaHTVei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 17:34:38 -0400
X-Greylist: delayed 1744 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Aug 2014 17:34:38 EDT
From: Matevz Langus <matevz.langus@borea.si>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: PCI: minimal alignment of resources
Message-Id: <72232BCB-CCF2-4BA3-9F40-53D385C83D6B@borea.si>
Date: Wed, 20 Aug 2014 23:05:29 +0200
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to ask if somebody is aware of a correct way to change they way kernel aligns PCI resources. By default it uses minimal alignment of 1 MB.

Due to the hardware limitation I would need to change that down to 64 kB. With this change PCI Endpoints with many small BARs would fit into limited memory space available on the RC.
This could be useful for all smaller embedded systems.

It looks just changing aligns in pbus_size_mem (in file setup-bus.c) works but not with all PCI EP drivers. Some will crash during init.

Regards,
  Matevz Langus