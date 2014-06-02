Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaFBLC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:02:28 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:61665 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaFBLCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:02:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Mon, 02 Jun 2014 13:02:07 +0200
Message-ID: <142924495.p3tVTERnnG@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <0ab4392c-d89d-4277-914d-1696f455daab@email.android.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <8618458.1EVJCoVbkH@wuerfel> <0ab4392c-d89d-4277-914d-1696f455daab@email.android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QhJnBhSvwSkofJdPVaDBMUwdbdcwYruw/hF6s9q5pnS
 vE84rvg93Tc0p4uFQKLxebzhy29CZHzmuY78XhZog9NyzGEuty
 8IlsLMlsL+OiS+Gj/lfMe8AB96cD5U2cEWLxfj/U55SE4gKimN
 EhzygnJ4kPqMvHYuRObFgU99l+uqLHJD7KS8B6xwuRBUYoofnv
 Fys59Omtzf/FUXIQdRBdAftmI+/uDgjpqjrZ+1zEY3SzBZ/BAY
 G0WejfapIYM1VCj7/FWaDBxXaoWp/v7LhoNdjVxAZF8NuSSCyR
 C9yDykgpxmPjHcB1T5bE77vscv51MUGwy/c1OmF69QEeeACVMs
 8D96IJ8ImOqNOdh5u0iM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 June 2014 13:26:03 H. Peter Anvin wrote:
> Perhaps we should make this a kernel command line option instead, with the
> settings: error out on outside the standard window, or a date indicating the
> earliest date that should be recognized and do windowing (0 for no windowing,
> 1970 for retconning the Unix epoch as unsigned...)

What's wrong with compile-time errors? We have a pretty good understanding
of how time values are passed in the kernel, and we know they will all break
in 2038 for 32-bit kernels unless we do something about it.
 
> But again, the kernel is probably the least problem here...
 
I agree the glibc side is harder than this, but we have to get the kernel
into shape first (at the minimum we have to do the APIs), and there is enough
work to do here.

	Arnd
