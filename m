Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3CTFR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 01:17:26 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:64083 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3CTFRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 01:17:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAMhs6YzEFt8Rfk1a7iickpdZaE6MuLxQPp8UoX-eETrEi=D48A@mail.gmail.com>
References: <1363132417-15273-1-git-send-email-festevam@gmail.com>
	<CAMhs6YzEFt8Rfk1a7iickpdZaE6MuLxQPp8UoX-eETrEi=D48A@mail.gmail.com>
Date: Wed, 20 Mar 2013 02:17:24 -0300
Message-ID: <CAOMZO5DV1vgBakDDaUwOE-y9=DL-_31bKb792zq=mcEXfudWCw@mail.gmail.com>
Subject: Re: [PATCH] dma: ipu: ipu_idmac: Fix section mismatch
From: Fabio Estevam <festevam@gmail.com>
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: vinod.koul@intel.com, maxin.john@enea.com, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Wed, Mar 13, 2013 at 9:39 PM, Maxin B. John <maxin.john@gmail.com> wrote:
> On Wed, Mar 13, 2013 at 1:53 AM, Fabio Estevam <festevam@gmail.com> wrote:
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> Since commit 84c1e63c12 (dma: Remove erroneous __exit and __exit_p() references)
>> the following section mismatch happens:
>>
>> WARNING: drivers/built-in.o(.text+0x20f94): Section mismatch in reference from the function ipu_remove() to the function .exit.text:ipu_idmac_exit()
>> The function ipu_remove() references a function in an exit section.
>> Often the function ipu_idmac_exit() has valid usage outside the exit section
>> and the fix is to remove the __exit annotation of ipu_idmac_exit.
>>
>> Remove the '__exit' annotation from ipu_idmac_exit in order to fix it.
>
> Good catch...
> Acked-by:  Maxin B. John <maxin.john@enea.com>

Can this one be applied?
