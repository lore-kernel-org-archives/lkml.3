Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3LFIbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:31:14 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:56320 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3LFIbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:31:13 -0500
Message-ID: <52A18B4F.1070809@gmail.com>
Date: Fri, 06 Dec 2013 10:31:11 +0200
From: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: minchan@kernel.org, pavel@ucw.cz, sre@debian.org, pali.rohar@gmail.com,
        pc+n900@asdf.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: OMAPFB: CMA allocation failures
References: <1847426616.52843.1383681351015.JavaMail.apache@mail83.abv.bg> <A5506022381E423385022F79B40C6FAB@ivogl> <52A062A0.3070005@ti.com>
In-Reply-To: <52A062A0.3070005@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05.12.2013 13:25, Tomi Valkeinen wrote:
> How about the patch below? If I'm not mistaken (and I might) it reserves
> separate memory area for omapfb, which is not used by CMA.
>
> If it works, it should be extended to get the parameters via kernel
> cmdline, and use that alloc only if the user requests it.
>

YAY!!! That one seems to fix the issue.

Though I had to revert 7faa92339bbb1e6b9a80983b206642517327eb75 (well, I 
hacked check_horiz_timing_omap3 to always return 0). Otherwise I have 
"omapdss DISPC error: horizontal timing too tight" error when try to 
play anything above 320x240 or so. I'll look at the issue.

Regards,
Ivo
