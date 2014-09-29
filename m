Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaI2PHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:07:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18717 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaI2PHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:07:18 -0400
Date: Mon, 29 Sep 2014 11:07:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: sgruszka@redhat.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com
Subject: Re: [PATCH] Revert "xen/acpi-processor: fix enabling interrupts on
 syscore_resume"
Message-ID: <20140929150705.GG28012@laptop.dumpdata.com>
References: <1412002276-30873-1-git-send-email-konrad.wilk@oracle.com>
 <5429730E.1050506@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5429730E.1050506@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 03:56:14PM +0100, David Vrabel wrote:
> On 29/09/14 15:51, Konrad Rzeszutek Wilk wrote:
> > This reverts commit cd979883b9ede90643e019f33cb317933eb867b4.
> > 
> > As it actually never gets called on the initial domain when
> > resuming. That is after we suspend and go in resume, the
> > do_suspend (from manage.c) is never called (it is if it
> > was running as a guest)- so the 'resume' functionality of the driver
> > was never called.
> > 
> > Which means that this whole patch was pointless (well, it did
> > remove the WARNING splat).
> > 
> > This patch reverts the patch and allows the C and P states to
> > be uploaded to the hypervisor on ACPI S3 resume of the
> > initial domain. It sadly brings back the WARNING splat which
> > will have to be dealt with at some point.
> 
> Incorrectly enabling interrupts in contexts where this is not permitted
> is not just harmless "WARNING splat".
> 
> This has been broken since 3.15-rc1 without anyone else noticing so I
> think we can afford to take a bit more time and fix the original bug
> properly.

That certainly can be done (perhaps as a next patch). But that won't get
done by for a good month or so (-EOVERLOADED).
> 
> David
