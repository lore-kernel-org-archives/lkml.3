Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab3FWJ5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 05:57:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47778 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab3FWJ5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 05:57:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, pavel@ucw.cz, len.brown@intel.com,
        gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCHv v3] power: Include additional information in pm_print_times
Date: Sun, 23 Jun 2013 12:07:02 +0200
Message-ID: <2168940.loyeqX9NTF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371949550.3137.16.camel@joe-AO722>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com> <2732229.sfB5fHUFTc@vostro.rjw.lan> <1371949550.3137.16.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 22, 2013 06:05:50 PM Joe Perches wrote:
> On Sat, 2013-06-22 at 21:52 +0200, Rafael J. Wysocki wrote:
> > On Friday, June 21, 2013 07:27:22 PM Joe Perches wrote:
> > > On Sat, 2013-06-22 at 02:24 +0200, Rafael J. Wysocki wrote:
> > > > Namely, there are tools that use these messages to create suspend/resume time
> > > > charts and they will stop working after the proposed changes.
> > > 
> > > dmesg output isn't guaranteed to be stable.
> > 
> > So?
> 
> So even if new information was only appended to
> the existing line, the script could break.

In this particular case, if it is written sanely, it won't.

> If any script needs something stable it should
> depend on information available through other
> sources like trace or proc or sysfs.

That is clearly impossible in this particular case, though.

> Tools that use dmesg should adapt to whatever gets
> thrown at it and handle the output from whatever
> kernel versions the script supports.
> 
> For instance, what happens to the script when
> console_level is set to 1?

You know, these particular messages are not printed without initcall_debug in
the command line and the people who use them for diagnostics usually generate
them on purpose and *then* feed the log to the script (or tool).

> Requiring that no one can change a dmesg to
> add or improve the content for readability
> or intelligibility I think unreasonable.

In general, you'd be right, but this is not a general case.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
