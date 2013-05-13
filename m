Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab3EMLk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 07:40:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:32100 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab3EMLkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 07:40:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,662,1363158000"; 
   d="scan'208";a="336734653"
Date: Mon, 13 May 2013 14:44:32 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: implement acpi_os_get_timer() according the spec
Message-ID: <20130513114432.GK20562@intel.com>
References: <1368440871-27552-1-git-send-email-mika.westerberg@linux.intel.com>
 <9521576.ePuIMg9qsX@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9521576.ePuIMg9qsX@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 01:38:46PM +0200, Rafael J. Wysocki wrote:
> On Monday, May 13, 2013 01:27:51 PM Mika Westerberg wrote:
> > ACPI Timer() opcode should return monotonically increasing clock with 100ns
> > granularity. Implement this with the help of ktime_get().
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> That looks reasobable.  Have you tested it?

Very lightly. Basically I added some debug printks() between two
successsive calls of Timer() and it seemed like it returned correct time.

It is certainly better than returning t+1 every time Timer() is called :)
