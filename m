Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaGCI31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:29:27 -0400
Received: from smtp-out-164.synserver.de ([212.40.185.164]:1112 "EHLO
	smtp-out-164.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGCI3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:29:24 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17223
Message-ID: <53B51462.1090805@metafoo.de>
Date: Thu, 03 Jul 2014 10:29:22 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, vinod.koul@intel.com,
        dan.j.williams@intel.com, tiwai@suse.de,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        joelf@ti.com, nsekhar@ti.com
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v3 4/5] ALSA: pcm_dmaengine: Correct support for 24bits
 physical sample widths
References: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com> <1404363116-10538-5-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1404363116-10538-5-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 06:51 AM, Peter Ujfalusi wrote:
> In case of _3LE/_3BE formats the samples are stored in 3 consecutive bytes
> without padding it to 4 bytes. This means that the DMA needs to be able to
> support 3 bytes word length in order to read/write the samples from memory
> correctly. Originally the code treated 24 bits physical length samples as
> they were 32 bits which leads to corruption when playing or recording audio.
>
> The hw.formats field has already been prepared to exclude formats not
> supported by the DMA engine in use, which means that only on platforms where
> 3 bytes is supported by the DMA will be able to use this format.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

