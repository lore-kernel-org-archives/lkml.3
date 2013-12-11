Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab3LKOBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:01:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:9196 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab3LKOBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:01:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,872,1378882800"; 
   d="scan'208";a="442414904"
Date: Wed, 11 Dec 2013 16:00:15 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: James Hogan <james@albanarts.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        James Hogan <james.hogan@imgtec.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Tim Kryger <tim.kryger@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: Re: [PATCH] serial: 8250_dw: Fix LCR workaround regression
Message-ID: <20131211140014.GF28456@xps8300>
References: <1386714484-30251-1-git-send-email-james@albanarts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386714484-30251-1-git-send-email-james@albanarts.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 10, 2013 at 10:28:04PM +0000, James Hogan wrote:
> From: James Hogan <james.hogan@imgtec.com>
> 
> Commit c49436b657d0 (serial: 8250_dw: Improve unwritable LCR workaround)
> caused a regression. It added a check that the LCR was written properly
> to detect and workaround the busy quirk, but the behaviour of bit 5
> (UART_LCR_SPAR) differs between IP versions 3.00a and 3.14c per the
> docs. On older versions this caused the check to fail and it would
> repeatedly force idle and rewrite the LCR register, causing delays and
> preventing any input from serial being received.
> 
> This is fixed by masking out UART_LCR_SPAR before making the comparison.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Tim Kryger <tim.kryger@linaro.org>
> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: Matt Porter <matt.porter@linaro.org>
> Cc: Markus Mayer <markus.mayer@linaro.org>
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Tested-by: Tim Kryger <tim.kryger@linaro.org>
> Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

I tested this with HW without the busy functionality
(UART_16550_COMPATIBLE == yes). No problems here. FWIW:

Tested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>


-- 
heikki
