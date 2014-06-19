Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbaFSRvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:51:50 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:48412 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaFSRvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:51:49 -0400
Message-ID: <53A3232E.4080601@acm.org>
Date: Thu, 19 Jun 2014 19:51:42 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: josh@joshtriplett.org, Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bug: Fix CONFIG_BUG=n BUG_ON()
References: <53A2E573.6080407@acm.org> <5061693.b4BPIj9quA@wuerfel> <20140619172142.GA15696@cloud>
In-Reply-To: <20140619172142.GA15696@cloud>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/14 19:21, josh@joshtriplett.org wrote:
> That's exactly what BUG_ON becomes if CONFIG_BUG=y, and that
> significantly increases kernel size; if you want that, set CONFIG_BUG=y.
> BUG_ON should continue to compile to nothing if CONFIG_BUG=n, or
> CONFIG_BUG=n has no reason to exist.

Hello Josh,

I wasn't aware that the current behavior of BUG_ON() with CONFIG_BUG=n
was intentional. The reason I started looking into this is because
different compiler warnings are generated for code with BUG_ON(1)
statements when building against a kernel with CONFIG_BUG=y or
CONFIG_BUG=n. There is an easy alternative though: changing BUG_ON(1)
into BUG() in my code.

Bart.

