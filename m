Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaI2O4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:56:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:34800 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaI2O4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:56:20 -0400
X-IronPort-AV: E=Sophos;i="5.04,620,1406592000"; 
   d="scan'208";a="177124516"
Message-ID: <5429730E.1050506@citrix.com>
Date: Mon, 29 Sep 2014 15:56:14 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, <sgruszka@redhat.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] Revert "xen/acpi-processor: fix enabling interrupts on
 syscore_resume"
References: <1412002276-30873-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1412002276-30873-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/14 15:51, Konrad Rzeszutek Wilk wrote:
> This reverts commit cd979883b9ede90643e019f33cb317933eb867b4.
> 
> As it actually never gets called on the initial domain when
> resuming. That is after we suspend and go in resume, the
> do_suspend (from manage.c) is never called (it is if it
> was running as a guest)- so the 'resume' functionality of the driver
> was never called.
> 
> Which means that this whole patch was pointless (well, it did
> remove the WARNING splat).
> 
> This patch reverts the patch and allows the C and P states to
> be uploaded to the hypervisor on ACPI S3 resume of the
> initial domain. It sadly brings back the WARNING splat which
> will have to be dealt with at some point.

Incorrectly enabling interrupts in contexts where this is not permitted
is not just harmless "WARNING splat".

This has been broken since 3.15-rc1 without anyone else noticing so I
think we can afford to take a bit more time and fix the original bug
properly.

David
