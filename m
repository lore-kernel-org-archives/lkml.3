Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaBQNkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:40:12 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42188 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395AbaBQNkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:40:10 -0500
X-Sasl-enc: zNwaQwbjk7aipH1p0FXLb/mO8zv8s9JyYXrkn+71X6tw 1392644408
Date: Mon, 17 Feb 2014 10:40:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Jan Beulich <JBeulich@suse.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Issue a warning if number of present CPUs > maxcpus
 and CONFIG_HOTPLUG=n
Message-ID: <20140217134006.GA14786@khazad-dum.debian.net>
References: <20140215150223.63bb52fb@hananiah.suse.cz>
 <5301D7AA020000780011CBE9@nat28.tlf.novell.com>
 <20140217110402.7e4fc211@hananiah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217110402.7e4fc211@hananiah.suse.cz>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014, Petr Tesarik wrote:
> Well, if the user passes both nr_cpus and maxcpus parameters to the
> kernel, I think it's fair to issue two warnings. But if everyone agrees
> that only the maxcpus warning should be printed in that case, I can
> send a version 2 of my patch.

Please remember that the market is full of motherboards with the extremely
annoying behaviour of declaring ACPI objects for CPU cores that will never
be available.  This includes a large number of workstation and server boards
at the very least, from at least one rather large vendor.

As far as I know, we still don't have a way to realiably detect this and get
rid of the ghost processors which will *NEVER* become online.  Setting
maxcpus or nr_cpus manually is the current way to avoid wasting runtime
resources because of phantom cores that will never become reality.

So, when you fix the bug that always supress the warnings, you will at the
same time cause a regression on those boxes, which will now print undesired
warnings.  If the user has manually set nr_cpus or maxcpus, maybe it would
be best to not print any warnings or alternatively to downgrade them to
debug level?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
