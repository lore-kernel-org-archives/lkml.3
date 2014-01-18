Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaARQFg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 11:05:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47524 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaARQFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 11:05:34 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Jan 2014 17:05:09 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] firewire: Enable remote DMA above 4 GB
Message-ID: <20140118170509.1181a887@stein>
In-Reply-To: <20140118163315.2757ce26@stein>
References: <20140118163315.2757ce26@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18 Stefan Richter wrote:
> This makes all of a machine's memory accessible to remote debugging via
> FireWire, using the physical response unit (i.e. RDMA) of OHCI-1394 link
> layer controllers.
> 
> This requires actual support by the controller.  The only ones currently
> known to support it are Agere/LSI FW643.  Most if not all other OHCI-1394
> controllers do not implement the optional Physical Upper Bound register.
> With them, RDMA will continue to be limited to the lowermost 4 GB.
[...]

PS,
this patch does not switch remote DMA on.
It only increases the range of remote access to all memory (instead of just
4 GB) _when_ remote DMA was switched on by other means.  The latter is
achieved by setting CONFIG_FIREWIRE_OHCI_REMOTE_DMA, or by a module
parameter introduced by commit 8bc588e0e585 of linux1394.git, or if the
physical DMA filter is opened through firewire-sbp2.
-- 
Stefan Richter
-=====-====- ---= =--=-
http://arcgraph.de/sr/
