Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaLEMZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:25:22 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:65246 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaLEMZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:25:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, "agraf@suse.de" <agraf@suse.de>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
Date: Fri, 05 Dec 2014 13:24:49 +0100
Message-ID: <2131163.V0fUaF9isN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141205110507.GB28339@e104818-lin.cambridge.arm.com>
References: <1417707993-82290-1-git-send-email-agraf@suse.de> <3551792.oHatG1W6W1@wuerfel> <20141205110507.GB28339@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Y12TLBbmvAlUmk0ME2VkMNWXqjiH/iV5tq+y4jNPFrLB9HIM1Bp
 /FRl9oBICpI/immOD2cQMx9Xc+5zaPdXvVFcGAmTMiqawPPJTWNgKIcB28E6xFJzR4wXXLh
 uLdZt53dEzEli6Mz4D3aNOn1kKukbHLNWhf/nmBW7PCpqolvWGbK3lKg88zldeD082WRPOC
 8IXKHQytmB7hfbQEv2eJA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2014 11:05:07 Catalin Marinas wrote:
> 
> > Should we add support for 64k-pages in the arm32 kernel as well now?
> 
> 32-bit LPAE doesn't support 64K pages but IIRC the classic MMU does
> (though I have to check whether it was optional). But it's not feasible
> to enable this in a 32-bit environment because of the memory wasted with
> large pages (on average 32KB per mapped file, possibly even more if you
> have lots of small files).

That sounds like a tradeoff that some users might be willing to make.

I remember that with ps3-linux, a lot of people wanted to enable 64k-pages
because the Cell processor has such a small number of TLB entries (256 or
1024), but Linux only has around 200MB of memory available. I believe
there are arm32 machines with more RAM and fewer TLBs.

	Arnd
