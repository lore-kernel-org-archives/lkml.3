Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaE0LQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:16:23 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.102]:34481 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaE0LQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:16:22 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2014 07:16:21 EDT
Date: Tue, 27 May 2014 13:10:03 +0200
From: Bernhard Walle <bernhard@bwalle.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org
Subject: Regression in hyperv network driver in 3.14
Message-ID: <20140527111003.GA2214@kepler.fritz.box>
Mail-Followup-To: Haiyang Zhang <haiyangz@microsoft.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Df-Sender: MTIyNzgwNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

using a 3.14 kernel in a Linux VM running on HyperV (Windows Server 2008
R2) we get following error:

   hv_netvsc: hv_netvsc channel opened successfully
   hv_netvsc vmbus_0_9 (unregistered net_device): Unable to complete receive buffer initialization with NetVsp - status 2
   hv_netvsc vmbus_0_9 (unregistered net_device): unable to connect to NetVSP - -22
   hv_netvsc vmbus_0_9 (unregistered net_device): unable to add netvsc device (ret -22)
   hv_netvsc: probe of vmbus_0_9 failed with error -22

Bisecting the problem shows that commit
b679ef73edc251f6d200a7dd2396e9fef9e36fc3 is responsible. Reverting it
fixes the issue. Even only changing NETVSC_RECEIVE_BUFFER_SIZE to 2M
fixes the issue!

The virtual machine has 2 GiB of memory and 4 CPUs.

Can I provide more information to track down the problem?


Regards,
Bernhard

