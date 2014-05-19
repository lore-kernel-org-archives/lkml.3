Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbaESSM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:12:28 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:59231 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaESSM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:12:26 -0400
Date: Mon, 19 May 2014 18:12:18 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Arnd Bergmann <arnd@arndb.de>
CC: Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
In-Reply-To: <5228220.XfC7baN05k@wuerfel>
Message-ID: <Pine.LNX.4.64.1405191806230.25418@digraph.polyomino.org.uk>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
 <4254860.84WuxPQ4j9@wuerfel> <Pine.LNX.4.64.1405191431210.25418@digraph.polyomino.org.uk>
 <5228220.XfC7baN05k@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 19 May 2014 18:12:21.0986 (UTC) FILETIME=[E105A420:01CF738D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Arnd Bergmann wrote:

> A related question would be how you plan to support future CPU architectures
> that never had the 32-bit time_t in the kernel ABI. Would you also want
> to provide both 32 and 64 bit time_t to user space on those?

I'd expect those just to have 64-bit time_t in userspace (like x32) - 
choosing a different type for time_t from the start is a lot simpler than 
setting up a second set of interfaces with associated symbol versioning 
for an existing architecture.  This whole discussion started with the 
question of whether Nios II should be such an architecture....

(Other variants may arise as well, e.g. architectures with existing kernel 
support that only get glibc support later.)

-- 
Joseph S. Myers
joseph@codesourcery.com
