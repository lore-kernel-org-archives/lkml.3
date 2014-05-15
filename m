Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaEOAiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 20:38:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34791 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbaEOAiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 20:38:01 -0400
Message-ID: <53740C42.3000906@zytor.com>
Date: Wed, 14 May 2014 17:37:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>, pavel@ucw.cz
CC: arik@wizery.com, david.gnedt@davizone.at, eliad@wizery.com,
        jan.nikitenko@gmail.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com, luca@coelho.fi, tony@atomide.com
Subject: Re: [PATCH v2 1/3] lib/crc7: Shift crc7() output left 1 bit
References: <20140511100211.1334.qmail@ns.horizon.com>
In-Reply-To: <20140511100211.1334.qmail@ns.horizon.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 03:02 AM, George Spelvin wrote:
> From 770aa22e6c9c92027e3e21797192ccabb3e7c70e Mon Sep 17 00:00:00 2001
> From: George Spelvin <linux@horizon.com>
> Date: Sat, 10 May 2014 10:32:57 -0400
> Subject: [PATCH v2 1/3] lib/crc7: Shift crc7() output left 1 bit
> 
> This eliminates a 1-bit left shift in every single caller,
> and makes the inner loop of the CRC computation more efficient.
> 
> Renamed crc7 to crc7_be (big-endian) since the interface changed.
> 
> Also purged #include <linux/crc7.h> from files that don't use it at all.
> 
> Signed-off-by: George Spelvin <linux@horizon.com>

If the whole point of this is to use it for MMC/SD cards, why not just
also subsume the OR 1 and call it crc7_mmc() or something like that.

(Which I'm all for doing... I don't know of any other crc7 users.)

	-hpa


