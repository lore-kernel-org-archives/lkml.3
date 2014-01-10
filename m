Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaAJJYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:24:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12484 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaAJJYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:24:01 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-0e-52cfbc2babb1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        " Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        " H. Peter Anvin" <hpa@linux.intel.com>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert
 "intel_idle: mark states tables with __initdata tag"
Date: Fri, 10 Jan 2014 10:23:36 +0100
Message-id: <1540348.rFAN0gMFRZ@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <2380177.4Omy8JvF8m@vostro.rjw.lan>
References: <1389252628-1033-1-git-send-email-jiang.liu@linux.intel.com>
 <1987543.MckBKZrloE@amdc1032> <2380177.4Omy8JvF8m@vostro.rjw.lan>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=utf-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jAV3tPeeDDFq2SVnc/HGZxWLW9v1A
	YspeJoudD9+yWVzeNYfN4nPvEUaLxyveslucOX2J1YHDY/Gel0wem1Z1snnMOxnoseVqO4vH
	501yAaxRXDYpqTmZZalF+nYJXBnPVy5kLejmqlj0TbiB8R17FyMnh4SAicSO7ZfYIGwxiQv3
	1gPZXBxCAosYJdq272ACSQgJtDBJ7JlcC2KzCVhJTGxfxQhiiwhoS8ztOcUM0sAs0MwkMf/U
	J6CpHBzCAmESD65ygtSwCKhKLHi6CyzMK6ApsaXbHCQsKuAJtHclG0iYU8BA4vskToi1PYwS
	zScus4DU8AoISvyYfA/MZhaQl9i3fyorSD2zgLrElCm5ExgFZiGpmoWkahZC1QJG5lWMoqkF
	yQXFSem5RnrFibnFpXnpesn5uZsYwUH+THoH46oGi0OMAhyMSjy8BbPOBwmxJpYVV+YeYpTg
	YFYS4Z28CyjEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qB
	sePtext1n+u3k3uENy3q/2P/a8sGpQ0rvZtLNid8Dc3deMCzeErK/glnJTKfbXrwZaKRS45C
	rEzVueKzahbflrl+/yc4Rffy1Z2C7scKLr9+xbbKq+9T3r8/Ow6Vhi//t2mn+9Nzy2OlTd/J
	Bk32juPPDtn4gns72wbZyfkOJ6uvVP3n0m0+912JpTgj0VCLuag4EQBEqKNjbgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 09, 2014 02:38:14 PM Rafael J. Wysocki wrote:
> Hi,
> 
> On Thursday, January 09, 2014 02:20:22 PM Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > On Thursday, January 09, 2014 03:30:26 PM Jiang Liu wrote:
> > > This reverts commit 9d046ccb98085f1d437585f84748c783a04ba240.
> > > 
> > > Commit 9d046ccb98085 marks all state tables with __initdata, but
> > > the state table may be accessed when doing CPU online, which then
> > > causing system crash as below:
> > 
> > Uh, sorry for that - it most likely got missed since I tested it
> > together with intel_idle_cpu_init() removal patches (they are in
> > Rafael's PM tree now).
> > 
> > Anyway, better than reverting it altogether would be to fix it by
> > backporting the following patch:
> > 
> > 	http://lkml.org/lkml/2013/12/20/372
> > 
> > Could you please try to solve the issue this way?
> 
> No, it's too late for that as far as 3.13 is concerned.
> 
> I have the patch above queued up for 3.14, though, so do you think that the
> commit being reverted here can be safely re-applied on top of it?

Yes, the reverted commit can be safely re-applied on top of this patch.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

