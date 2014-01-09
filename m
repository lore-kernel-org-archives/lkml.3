Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaAINYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:24:32 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51352 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752214AbaAINYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:24:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        " Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        " H. Peter Anvin" <hpa@linux.intel.com>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "intel_idle: mark states tables with __initdata tag"
Date: Thu, 09 Jan 2014 14:38:14 +0100
Message-ID: <2380177.4Omy8JvF8m@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1987543.MckBKZrloE@amdc1032>
References: <1389252628-1033-1-git-send-email-jiang.liu@linux.intel.com> <1987543.MckBKZrloE@amdc1032>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, January 09, 2014 02:20:22 PM Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Thursday, January 09, 2014 03:30:26 PM Jiang Liu wrote:
> > This reverts commit 9d046ccb98085f1d437585f84748c783a04ba240.
> > 
> > Commit 9d046ccb98085 marks all state tables with __initdata, but
> > the state table may be accessed when doing CPU online, which then
> > causing system crash as below:
> 
> Uh, sorry for that - it most likely got missed since I tested it
> together with intel_idle_cpu_init() removal patches (they are in
> Rafael's PM tree now).
> 
> Anyway, better than reverting it altogether would be to fix it by
> backporting the following patch:
> 
> 	http://lkml.org/lkml/2013/12/20/372
> 
> Could you please try to solve the issue this way?

No, it's too late for that as far as 3.13 is concerned.

I have the patch above queued up for 3.14, though, so do you think that the
commit being reverted here can be safely re-applied on top of it?

Rafael

