Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbbAVOWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:22:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:27463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbbAVOW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:22:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,449,1418112000"; 
   d="scan'208";a="641033114"
Date: Thu, 22 Jan 2015 14:22:25 +0000 (UTC)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.lm.intel.com
To: Yan Liu <yan@purestorage.com>
cc: Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO command
 is being issued via a block device file descriptor
In-Reply-To: <CADMsRTZjajAj682a5FH-AmpphoQ4vw5QxqnJiGEQ+Jg_f7TvoA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1501221409080.15481@localhost.lm.intel.com>
References: <1421886503-25276-1-git-send-email-yan@purestorage.com> <alpine.LNX.2.00.1501220035170.15481@localhost.lm.intel.com> <CADMsRTZjajAj682a5FH-AmpphoQ4vw5QxqnJiGEQ+Jg_f7TvoA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2064116865-1421936546=:15481"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2064116865-1421936546=:15481
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 21 Jan 2015, Yan Liu wrote:
> For IO passthrough command, it uses an IO queue associated with the device. Actually, this patch does not modify that part.
> This patch is not really focused on io queues; instead, it is more about namespace protection from other namespace's user ios. The patch here doesn't prevent a user submitting completely arbitrary commands on IO queues. One still can
> do it through a char dev file descriptor. However, when a user explicitly chooses a namespace's file descriptor, it is unlikely that she/he tries to issue an io command to a different namespace. Maybe in that case someone should to
> use a new admin command.

Oh, I just realized your patch is not for the blk-mq version of this
driver. The mainline kernel uses blk-mq and is a little different in
this path. My mistake, you're right the command works the same as before
using the character device here. In that case, this seems very reasonable,
but doesn't merge upstream.
--8323328-2064116865-1421936546=:15481--
