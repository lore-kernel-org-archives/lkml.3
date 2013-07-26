Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab3GZQ72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:59:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48528 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab3GZQ70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:59:26 -0400
Message-ID: <51F2AAC5.6020808@zytor.com>
Date: Fri, 26 Jul 2013 09:58:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCH 2/2] x86: add early quirk for reserving Intel graphics
 stolen memory v3
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org> <1374770269-3223-3-git-send-email-jbarnes@virtuousgeek.org>
In-Reply-To: <1374770269-3223-3-git-send-email-jbarnes@virtuousgeek.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 09:37 AM, Jesse Barnes wrote:
> Systems with Intel graphics controllers set aside memory exclusively for
> +	/*
> +	 * Almost universally we can find the Graphics Base of Stolen Memory
> +	 * at offset 0x5c in the igfx configuration space. On a few (desktop)
> +	 * machines this is also mirrored in the bridge device at different
> +	 * locations, or in the MCHBAR.
> +	 */

This comment makes me nervous.  It isn't clear to me if it is saying:

- All igfx devices has the graphics base at 0x5c, a few have it in
  other places, too (which doesn't matter, we can use 0x5c anyway), or
- Most igfx devices have the graphics base at 0x5c, some don't, and we
  hope and pray we're not on one of those systems because we're not
  checking.

I assume it is the former, but it really needs to be phrased better.

	-hpa


