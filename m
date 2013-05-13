Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3EMOlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:41:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39684 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751435Ab3EMOlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:41:06 -0400
Message-ID: <1368456065.1913.6.camel@joe-AO722>
Subject: Re: [PATCH 2/2] mfd: si476x: Do not use binary constants
From: Joe Perches <joe@perches.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Mon, 13 May 2013 07:41:05 -0700
In-Reply-To: <CAHQ1cqFL4WNq5QfdCk3jWmr0ATEukdrxG0qArn5Zwkj_ZVOxvA@mail.gmail.com>
References: <1368044622-25645-1-git-send-email-geert@linux-m68k.org>
	 <1368044622-25645-2-git-send-email-geert@linux-m68k.org>
	 <CAHQ1cqFL4WNq5QfdCk3jWmr0ATEukdrxG0qArn5Zwkj_ZVOxvA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 07:29 -0700, Andrey Smirnov wrote:
> On Wed, May 8, 2013 at 1:23 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > Gcc < 4.3 doesn't understand binary constanrs (0b*):
[]
> > Hence use hexadecimal constants (0x*) instead.
[]
> I really begin to regret my decision to use those constants in place
> instead of defining a corresponding symbol in a header file. Because
> now that those binary constants are replaced the code looks a little
> bit more cryptic. Currently I am doing some additional work on the
> driver(adding the support of a different chip) and I'll try to make
> patches to address the issue.
[]
> > diff --git a/drivers/mfd/si476x-cmd.c b/drivers/mfd/si476x-cmd.c
[]
> > @@ -772,16 +772,16 @@ int si476x_core_cmd_am_rsq_status(struct si476x_core *core,
[]
> > +       report->snrhint         = 0x08 & resp[1];
> > +       report->snrlint         = 0x04 & resp[1];
> > +       report->rssihint        = 0x02 & resp[1];
> > +       report->rssilint        = 0x01 & resp[1];

You might also want to change all the
u8 report variables to bool.


