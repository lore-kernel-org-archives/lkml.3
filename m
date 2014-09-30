Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaI3UON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:14:13 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64836 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750935AbaI3UOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:14:11 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jean Delvare <jdelvare@suse.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [PATCH v2] i2c: move acpi code back into the core
Date: Tue, 30 Sep 2014 22:34:07 +0200
Message-ID: <1773097.ooYUbTzKBv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140930204607.2ab3baed@endymion.delvare>
References: <1411594591-5048-1-git-send-email-wsa@the-dreams.de> <20140930160352.GV1786@lahna.fi.intel.com> <20140930204607.2ab3baed@endymion.delvare>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 30, 2014 08:46:07 PM Jean Delvare wrote:
> On Tue, 30 Sep 2014 19:03:52 +0300, Mika Westerberg wrote:
> > On Tue, Sep 30, 2014 at 12:55:20PM +0200, Jean Delvare wrote:
> > > The only thing which I find curious is that ACPI_I2C_OPREGION depends
> > > on I2C=y. Is this limitation a leftover from when the code was split to
> > > a separate file? It builds just fine with I2C=m, and I can't see why it
> > > wouldn't work. I have a patch to enable that, I can send it if it is
> > > the right thing to do. But maybe I'm missing something?
> > 
> > I think reason for the limitation is that if there happens to be some
> > AML code that is currently using the I2C operation region and the user
> > decides to unload the i2c-core.ko module or along those lines.
> 
> If that's the reason then shouldn't it be addressed by proper reference
> counting instead? We could simply increase the module reference count
> when entering the critical section, and decrease it when we're done.

That is not so simple in practice, because the code containing the
critical sections in question is AML and not part of the kernel.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
