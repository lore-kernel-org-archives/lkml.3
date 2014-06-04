Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaFDVRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:17:36 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54168 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751410AbaFDVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:17:35 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        lenb@kernel.org, mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        arjan@linux.intel.com, rui.zhang@intel.com, luto@amacapital.net
Subject: Re: [PATCH] idle, thermal, acpi: Remove home grown idle implementations
Date: Wed, 04 Jun 2014 23:34:51 +0200
Message-ID: <1509308.hu7EZQqxxC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140604015812.140a00d1@jacob-desktop>
References: <20140604085418.GA11096@twins.programming.kicks-ass.net> <20140604015812.140a00d1@jacob-desktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 04, 2014 01:58:12 AM Jacob Pan wrote:
> On Wed, 4 Jun 2014 10:54:18 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > 
> > I'm still sitting on this patch. Jacub you were going to make it play
> > nice with QoS?
> > 
> I had a patchset to work through system PM QOS and still maintain the
> idle injection efficiency. When I saw you did not merge the patch
> below, I thought you have abandoned it :)
> 
> The only issue as per our last discussion is the lack of notification
> when PM QOS cannot be met. But that is intrinsic to PM QOS itself.
> 
> I also consulted with Arjan and looked at directly intercept with
> intel_idle since both intel_powerclamp and intel_idle are arch specific
> drivers. But I think that is hard to do at per idle period basis,
> since we should still allow "natural" idle during the forced idle time.
> 
> So, I think we can take a two stepped approach,
> 1. integrate your patch with a
> updated version of https://lkml.org/lkml/2013/11/26/534 such that there
> is no performance/efficiency regression.
> 2. add notification mechanism to system qos when constraints cannot be
> met.

And then there's a question about how the notification would be supposed to
work.  So I guess we can proceed with 1. and really leave 2. for some time
in the future ATM.

Rafael

