Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3GDRsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 13:48:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52786 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728Ab3GDRst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 13:48:49 -0400
Message-ID: <51D5B560.8050504@zytor.com>
Date: Thu, 04 Jul 2013 10:48:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 00/14] Platform Framebuffers and SimpleDRM
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 05:25 AM, David Herrmann wrote:
>   - What FB formats are common on x86 that we should add to SIMPLEFB_FORMATS?
>     (other than ARGB/XRGB32)

The common pixel formats on x86 are:

- Palettized 4-bit planar (bigendian, i.e. MSB to the left)
- Palettized 8-bit packed (one byte per pixel)
- 16-bit RGB555 (16-bit littleendian words with R=14:10, G=9:5, B=4:0)
- 16-bit RGB565 (16-bit littleendian words with R=15:11, G=10:5, B=4:0)
- 24-bit RGB888 in littleendian order (first byte in memory is B,
   second is G, third is R)
- 32-bit ARGB8888 (first byte in memory is B, second G, third R, fourth
   unused in the framebuffer proper)
- 32-bit RGB10:10:10 (I *believe* 32-bit littleendian words with
   R=29:20, G=19:10, B=9:0)

	-hpa

