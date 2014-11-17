Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaKQJoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:44:44 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:35292 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaKQJol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:44:41 -0500
Date: Mon, 17 Nov 2014 10:44:30 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V3 1/2] virtio: introduce methods of sanitizing device
 features
Message-ID: <20141117104430.54362e7d.cornelia.huck@de.ibm.com>
In-Reply-To: <20141117093701.GC20133@redhat.com>
References: <1416215838-21700-1-git-send-email-jasowang@redhat.com>
	<20141117093701.GC20133@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111709-0025-0000-0000-000002704FE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014 11:37:01 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Nov 17, 2014 at 05:17:17PM +0800, Jason Wang wrote:
> > Buggy host may advertised buggy host features (a usual case is that host
> > advertise a feature whose dependencies were missed). In this case, driver
> > should detect and disable the buggy features by itself.
> > 
> > This patch introduces driver specific sanitize_features() method which is
> > called just before features finalizing to detect and disable buggy features
> > advertised by host.
> > 
> > Virtio-net will be the first user.
> > 
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> Hmm this conflicts with virtio 1.0 work: we drop
> features as bitmap there.

But that's an implementation detail, no? We'll still need a way for the
driver to sanitize features, and I think this interface works just fine.

