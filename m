Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaCXP5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 11:57:50 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:50017 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbaCXP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 11:57:48 -0400
Message-ID: <1395676666.6440.19.camel@x220>
Subject: Re: [PATCH v2] NVMe: silence GCC warning on 32 bit
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org
Date: Mon, 24 Mar 2014 16:57:46 +0100
In-Reply-To: <CAMuHMdVMq30_XFLNzwjj6kXWVvasa8Ewog0MmOd1PNDQDuybqA@mail.gmail.com>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
	 <1392934261.15264.22.camel@x220> <alpine.LRH.2.03.1402210921010.4656@AMR>
	 <1393925767.3038.23.camel@x220> <20140324131104.GC5777@linux.intel.com>
	 <20140324133154.GD5777@linux.intel.com> <1395675399.6440.14.camel@x220>
	 <CAMuHMdVMq30_XFLNzwjj6kXWVvasa8Ewog0MmOd1PNDQDuybqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2014 15:57:46.0603 (UTC) FILETIME=[CC95FBB0:01CF4779]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-24 at 16:49 +0100, Geert Uytterhoeven wrote:
> On Mon, Mar 24, 2014 at 4:36 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > And as this is now unlikely to be in time for v3.14, we might decide to
> > dig deeper. It won't be the first time that a rather small change (say,
> > converting a variable from signed to unsigned) turns out be enough to
> > make GCC understand the flow of the code.
> 
> Anything we can do with factoring out the "if (!first)" in both branches?

That was basically my approach in version one: drop "first" all
together. Worked great: the warning was gone. But Keith noted that I
also completely broke the logic of the code. So I decided, after some
further attempts, to take the easy way out and and initialize "bvprv" to
{ NULL }.


Paul Bolle

