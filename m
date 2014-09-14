Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaINQdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:33:20 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56848 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752336AbaINQdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:33:19 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / platform / LPSS: disable async suspend/resume of LPSS devices
Date: Sun, 14 Sep 2014 18:52:52 +0200
Message-ID: <5973164.RGiBWmV7v9@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54133333.1020406@linux.intel.com>
References: <540E91F0.2060306@linux.intel.com> <20140910075026.GB13406@lahna.fi.intel.com> <54133333.1020406@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 13, 2014 01:53:55 AM Fu, Zhonghui wrote:
> 
> On 2014/9/10 15:50, Mika Westerberg wrote:
> > On Tue, Sep 09, 2014 at 01:36:48PM +0800, Fu, Zhonghui wrote:
> >> >From 6deb00230f5df68da3ca7490402a0c537bf386bb Mon Sep 17 00:00:00 2001
> >> From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
> >> Date: Tue, 9 Sep 2014 13:02:25 +0800
> >> Subject: [PATCH] ACPI / platform / LPSS: disable async suspend/resume of LPSS devices
> >>
> >> LPSS devices must suspend/resume in fixed order. Or some LPSS devices
> >> will hang during the transition to ACPI_STATE_D0 state.
> > In addition to the comment from Rafael, I would like to have more
> > details here why we must suspend/resume the LPSS devices in certain
> > order.
> Sorry for late response.
> 
> After the patch "ACPI / platform / LPSS: Enable async suspend/resume of LPSS devices(commit ID: 8ce62f85a81f57e86bc120ab690facc612223188)" was merged into upstream kernel, some LPSS devices(UART, I2C) frequently hang during resume. So, my patch is actually reverting that patch.

I suppose the Mika's question was more about whether or not you were able
to identify the exact reason why the LPSS devices in question stopped
resuming correctly after the above change.

Also, your patch is not actually revering the whole commit mentioned above, as
it did a couple of things more.  You're simply restoring the previous behavior,
which doesn't mean "reverting".

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
