Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3AUO3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:29:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51503 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3AUO3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:29:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 69/76] ARC: [Review] Multi-platform image #2: Board callback Infrastructure
Date: Mon, 21 Jan 2013 14:29:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <201301181505.10350.arnd@arndb.de> <50FD4C47.8080805@synopsys.com>
In-Reply-To: <50FD4C47.8080805@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301211429.38119.arnd@arndb.de>
X-Provags-ID: V02:K0:QW0HYKm/aKSkGdfIhg4loXKxF7SP/ikrKaZZTMvKUJs
 EaFyFFwkH1fZqUojy1OGuPoLVbqSFwrf5nKvlLBtQ59dZ0l1BG
 kxJF1LSga1h7aNXpVefJpdUyqLd8qckskufrD4E/h2ZCXrCPop
 89pSgA669zgHiDEKV8K75ICjlZvgP9qlhFkIf126jVIzYoTqUB
 3tqcdWCAqFqQUSt06+FqxRhjUw3eOKX1Pm/uTXu1QMmfwERPK5
 LJ1IFMy1bQBbWZcSHf1xJ8gv2qeY1ae0FOL3qChb6IRamslk0o
 zz4nXj+RE3n3Jn2QPPWaSu2WNQwNd4fZtbos2hd3dniMtRBMAe
 9UtS0CzbDQg8ucDqc2gQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Vineet Gupta wrote:
> OK - I'll make a note. BTW init_time was a recent addition, the reason being it's
> timing. For registering a clocksource, init_irq and init_smp are too early
> (timekeeping not yet up) while init_machine (arch initcall) seemed too late - but
> thinking again, it could well be done in there. I need to check with the relevant
> platform folks.

For linux-3.9, we're adding support to drivers/clocksource to keep the individual
clocksource drivers separate from the platform (on ARM). If you follow the same
model, you can just call the global clocksource init function from arch code
and it will find the right timer from the device tree, rather than having
to list it per platform.

> > It probably makese sense for you to keep the above structure
> > for now, but you can also think about obsoleting some
> > of the calls in the future. It may be a good idea to have
> > a default version for each of these but still allow overriding
> > them for maximum flexibility in the platform.
> 
> IMHO the default has to be NULL, unless the platform has a quirk. It would be
> cleaner (and easier to read) if any default was factored out into ARC common code.

Yes, that's what I meant.

	Arnd
