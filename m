Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3LCQDC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:03:02 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53258 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3LCQDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:03:00 -0500
Date: Tue, 3 Dec 2013 16:00:18 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Julien Grall <julien.grall@linaro.org>
Cc: xen-devel@lists.xenproject.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v2] xen/block: Correctly define structures in public
 headers on ARM32 and ARM64
Message-ID: <20131203160018.67542a53@alan.etchedpixels.co.uk>
In-Reply-To: <1386085237-8334-1-git-send-email-julien.grall@linaro.org>
References: <1386085237-8334-1-git-send-email-julien.grall@linaro.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Dec 2013 15:40:37 +0000
Julien Grall <julien.grall@linaro.org> wrote:

> On ARM (32 bits and 64 bits), the double-word is 8-bytes aligned. This will
> result on different structure from Xen and Linux repositories.
> 
> As Linux is using __packed__ attribute, it must have a 4-bytes padding before
> each "id" field.
> 
> This change breaks guest block support with older kernel. IMHO, it's acceptable
> because Xen on ARM is still on Tech Preview and the hypercall ABI is not yet
> freezed.

How does a guest ascertain which API to use ?

How does the patch ensure new kernels on existing hypervisor versions
don't break ?

What is the failure case given the alignment change seems potentially to
produce valid but incorrect I/O requests - can it cause corruption ?

It seems to me you should be defining

struct blkif_request_rw_v2

and using the correct version according to which API the hypervisor
requires, not just breaking it.

Alan
