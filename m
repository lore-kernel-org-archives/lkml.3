Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaFWK7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:59:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:37404 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbaFWK67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:58:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,529,1400050800"; 
   d="scan'208";a="561816760"
Message-ID: <1403521128.27368.2.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [PATCH] staging: goldfish: fix direct copy_to_user() from
 __iomem
From: Alan Cox <alan@linux.intel.com>
To: James A Shackleford <shack@linux.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 23 Jun 2014 11:58:48 +0100
In-Reply-To: <1403422178-20833-1-git-send-email-shack@linux.com>
References: <1403422178-20833-1-git-send-email-shack@linux.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-22 at 03:29 -0400, James A Shackleford wrote:
> This patch allocates a few pages and performs an ioread8_rep() from the bus
> address, which are then copied to userspace.  This fixes the sparse warning:
> 
> drivers/staging/goldfish/goldfish_audio.c:136:43: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/goldfish/goldfish_audio.c:136:43:    expected void const *from
> drivers/staging/goldfish/goldfish_audio.c:136:43:    got char [noderef] <asn:2>*read_buffer
> 
> which was a result of performing a copy_to_user() directly from the bus address
> to the userspace, which can be unsafe across some architectures.

Goldfish is a specific architecture. It shouldn't be doing direct
xcopies like that - which is why the code is in staging but at the same
time allocating a buffer each call and doing extra copies is not the
right answer.

It should be mapping the pages when they are first set up.

Alan


