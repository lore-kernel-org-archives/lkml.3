Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaEHHMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:12:54 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:49199 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbaEHHMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:12:53 -0400
Message-ID: <1399533171.19191.8.camel@x41>
Subject: Re: [PATCH v2] NVMe: silence GCC warning on 32 bit
From: Paul Bolle <pebolle@tiscali.nl>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Keith Busch <keith.busch@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Date: Thu, 08 May 2014 09:12:51 +0200
In-Reply-To: <1395675399.6440.14.camel@x220>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
	 <1392934261.15264.22.camel@x220> <alpine.LRH.2.03.1402210921010.4656@AMR>
	 <1393925767.3038.23.camel@x220> <20140324131104.GC5777@linux.intel.com>
	 <20140324133154.GD5777@linux.intel.com> <1395675399.6440.14.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 May 2014 07:12:51.0831 (UTC) FILETIME=[ECD3E870:01CF6A8C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew,

Paul Bolle schreef op ma 24-03-2014 om 16:36 [+0100]:
> On Mon, 2014-03-24 at 09:31 -0400, Matthew Wilcox wrote:
> > I should try things myself before opening my big mouth.  Weird.  Using
> > gcc-4.8, I see the same thing.  Guess I should just apply the patch,
> > though it feels wrong to be initialising an entire struct just to silence
> > a bogus compiler warning :-(
> 
> I noticed this difference on a 32 bit x86 machine and a 64 bit x86
> machine that are both running Fedora 20. They both should be at
> gcc-4.8.2 for quite some time now (if I grepped the yum log correctly).
> 
> Anyhow, the warning on 32 bit is rather noisy, so I wanted it gone. But
> my comments should make clear I'm not really happy with this patch. 
> 
> And as this is now unlikely to be in time for v3.14, we might decide to
> dig deeper. It won't be the first time that a rather small change (say,
> converting a variable from signed to unsigned) turns out be enough to
> make GCC understand the flow of the code.

This noisy warning is still seen when compiling v3.15-rc4 for x86 (32
bit, that is). Assuming this patch is not queued anywhere: is the
unsophisticated approach of my v2 acceptable or would you like me to try
and find the cause of this warning?


Paul Bolle

