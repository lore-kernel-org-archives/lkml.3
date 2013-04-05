Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162429Ab3DEVD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:03:56 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:48819 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162097Ab3DEVDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:03:54 -0400
MIME-Version: 1.0
In-Reply-To: <515F3948.40205@linux.vnet.ibm.com>
References: <20130324155153.GA8597@redhat.com> <515F3160.4020007@linux.vnet.ibm.com>
 <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com> <515F3948.40205@linux.vnet.ibm.com>
From: Roland Dreier <roland@kernel.org>
Date: Fri, 5 Apr 2013 14:03:33 -0700
X-Google-Sender-Auth: a1xYx1letEcEbZ_7Gpcu-UvEtQw
Message-ID: <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
To: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 1:51 PM, Michael R. Hines
<mrhines@linux.vnet.ibm.com> wrote:
> Sorry, I was wrong. ignore the comments about cgroups. That's still broken.
> (i.e. trying to register RDMA memory while using a cgroup swap limit cause
> the process get killed).
>
> But the GIFT flag patch works (my understanding is that GIFT flag allows the
> adapter to transmit stale memory information, it does not have anything to
> do with cgroups specifically).

The point of the GIFT patch is to avoid triggering copy-on-write so
that memory doesn't blow up during migration.  If that doesn't work
then there's no point to the patch.

 - R.
