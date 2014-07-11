Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaGKR2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:28:41 -0400
Received: from smtprelay0208.hostedemail.com ([216.40.44.208]:38351 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751386AbaGKR2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:28:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1
X-HE-Tag: queen36_680164ec1213e
X-Filterd-Recvd-Size: 2258
Message-ID: <1405099712.2796.19.camel@joe-AO725>
Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for AMD's
 GPUs
From: Joe Perches <joe@perches.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>,
        Kenneth Heitke <kheitke@codeaurora.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Date: Fri, 11 Jul 2014 10:28:32 -0700
In-Reply-To: <20140711170411.GJ1870@gmail.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
	 <1405029027-6085-8-git-send-email-oded.gabbay@amd.com>
	 <20140711170411.GJ1870@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 13:04 -0400, Jerome Glisse wrote:
> On Fri, Jul 11, 2014 at 12:50:09AM +0300, Oded Gabbay wrote:
[]
> > +static long kfd_ioctl(struct file *, unsigned int, unsigned long);
> 
> Nitpick, avoid unsigned int just use unsigned.

I suggest unsigned int is much more common (and better)
than just unsigned.

$ git grep -P '\bunsigned\s+(?!long|int|short|char)' -- "*.[ch]" | wc -l
20778

$ git grep -P "\bunsigned\s+int\b" -- "*.[ch]" | wc -l
98068

> > +static int kfd_open(struct inode *, struct file *);

It's also generally better to use types and names tno
improve how a human reads and understands the code.


