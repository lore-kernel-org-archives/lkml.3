Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbaFIMrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 08:47:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:25856 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbaFIMrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:47:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1002,1392192000"; 
   d="scan'208";a="443299558"
Date: Mon, 9 Jun 2014 15:47:00 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Benson Leung <bleung@chromium.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] platform/chrome: Probe multiple i2c adapters of the
 same name
Message-ID: <20140609124700.GJ1657@lahna.fi.intel.com>
References: <1401800524-28934-1-git-send-email-mika.westerberg@linux.intel.com>
 <CANLzEksLB1=+TePxgPRBhsGKpC-4tWB8JOh-Ey80Hj43LkVn=g@mail.gmail.com>
 <20140604083726.GN1730@lahna.fi.intel.com>
 <CANLzEkuAxGrRHtb=vFAm9AGws7Qyg3A_oQpAGGFaYEqP2A2g8g@mail.gmail.com>
 <alpine.DEB.2.02.1406062259070.31301@scotdoyle.com>
 <alpine.DEB.2.02.1406062316230.32568@scotdoyle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406062316230.32568@scotdoyle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 11:25:14PM +0100, Scot Doyle wrote:
> The chromeos_laptop module probes the first i2c adapter with a specific name
> for expected hardware. However, the Acer C720 Chromebook has two i2c
> adapters with the same name. This patch probes each i2c adapter with a
> specific name in turn, until locating the expected hardware.
> 
> Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
> CC: Benson Leung <bleung@chromium.org>
> CC: Mika Westerberg <mika.westerberg@linux.intel.com>

I don't have anything against this approach.

One comment though, if you happen to have two devices with the same
address but in different buses this can go wrong. Not sure how likely
that will happen.
