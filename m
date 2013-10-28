Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab3J1Xr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 19:47:27 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:42854 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788Ab3J1XrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 19:47:22 -0400
MIME-Version: 1.0
In-Reply-To: <1383000855-8377-2-git-send-email-ezequiel.garcia@free-electrons.com>
References: <1383000855-8377-1-git-send-email-ezequiel.garcia@free-electrons.com>
	<1383000855-8377-2-git-send-email-ezequiel.garcia@free-electrons.com>
Date: Mon, 28 Oct 2013 16:47:20 -0700
Message-ID: <CAPcyv4iQVoYCXz16T3N4MbdVJV7MoKKeL0wq9t9WF1Kf3gz3Bw@mail.gmail.com>
Subject: Re: [PATCH 2/2] dma: mv_xor: Use high_base mmio where appropriate
From: Dan Williams <dan.j.williams@intel.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        sachin.kamat@linaro.org, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding dmaengine ]

On Mon, Oct 28, 2013 at 3:54 PM, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
> Despite requesting two memory resources, called 'base' and 'high_base', the
> driver uses explicitly only the former. The latter is being used implicitly
> by addressing at offset +0x200, which in practice accesses high_base.
>
> Instead of relying in such trick, let's define the registers with the
> offset from high_base, and use high_base explicitly where appropriate.
>
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> ---
>  drivers/dma/mv_xor.c |  3 ++-
>  drivers/dma/mv_xor.h | 25 +++++++++++++------------
>  2 files changed, 15 insertions(+), 13 deletions(-)

Since it's unused I'd prefer a patch that just deletes xor_high_base.

--
Dan
