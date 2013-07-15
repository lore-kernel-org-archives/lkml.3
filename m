Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383Ab3GOQMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:12:09 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:43983 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab3GOQMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:12:07 -0400
Message-ID: <1373904672.24916.46.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI / memhotplug: Fix a stale pointer in error path
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Jul 2013 10:11:12 -0600
In-Reply-To: <1628443.pD3ROIrBQn@vostro.rjw.lan>
References: <1373474833-14047-1-git-send-email-toshi.kani@hp.com>
	 <1907509.WiI0tI5uDZ@vostro.rjw.lan>
	 <1373668116.24916.43.camel@misato.fc.hp.com>
	 <1628443.pD3ROIrBQn@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-13 at 01:53 +0200, Rafael J. Wysocki wrote:
> On Friday, July 12, 2013 04:28:36 PM Toshi Kani wrote:
> > On Fri, 2013-07-12 at 23:40 +0200, Rafael J. Wysocki wrote:
> > > On Friday, July 12, 2013 03:12:24 PM Toshi Kani wrote:
> > > > On Fri, 2013-07-12 at 23:13 +0200, Rafael J. Wysocki wrote:
> > > > > On Friday, July 12, 2013 03:01:15 PM Toshi Kani wrote:
> > > > > > On Fri, 2013-07-12 at 22:42 +0200, Rafael J. Wysocki wrote:
> > > > > > > On Friday, July 12, 2013 08:51:29 AM Toshi Kani wrote:
> > > > > > > > On Fri, 2013-07-12 at 09:24 +0900, Yasuaki Ishimatsu wrote:
> > > > > > > > > (2013/07/11 1:47), Toshi Kani wrote:
> > > > > > > > > > device->driver_data needs to be cleared when releasing its data,
> > > > > > > > > > mem_device, in an error path of acpi_memory_device_add().
> > > > > > > > > > 
> > > > > > > > > > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > > > > > > > > > ---
> > > > > > > > > 
> > > > > > > > > Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > > > > > > > 
> > > > > > > > Thanks Yasuaki!
> > > > > > > 
> > > > > > > Queued up as a fix for 3.11.
> > > > > > 
> > > > > > Thanks!
> > > > > > 
> > > > > > > Do we need that in -stable as well?
> > > > > > 
> > > > > > Good point.  Yes, we need that in -stable as well.
> > > > > 
> > > > > What's the oldest mainline major release that fix is applicable to?
> > > > 
> > > > The fix is applicable all ways up to 2.6.32.
> > > 
> > > For -stable I'll need to say some more about what practical consequences of
> > > the bug are.  Is it difficult to trigger?
> > 
> > The function evaluates _CRS of memory device objects, and fails when it
> > gets an unexpected resource or cannot allocate a memory.
> 
> OK, so this is essentially about surviving unexpected external input, which
> I suppose is serious enough.
>
> > A kernel crash
> > or data corruption may occur when the kernel accessed a stale pointer.
> > That said, I am not sure how critical this issue is for old kernels
> > since I do not think there are many platforms that support memory
> > hotplug today.
> 
> Which doesn't matter.  People may want to run 3.10.y on future hardware too.

Good point.  Thanks for the clarification!
-Toshi


