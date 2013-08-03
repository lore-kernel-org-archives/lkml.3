Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3HCBGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:06:11 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52887 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab3HCBGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:06:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
Date: Sat, 03 Aug 2013 03:16:22 +0200
Message-ID: <1689760.eY2GhS7V2b@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMP44s0wg2wxWAo9WRXzxxhG_RJ_rfOkPchCoUf7VVradczuqQ@mail.gmail.com>
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com> <3682340.ddGL4l7l22@vostro.rjw.lan> <CAMP44s0wg2wxWAo9WRXzxxhG_RJ_rfOkPchCoUf7VVradczuqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 02, 2013 08:04:52 PM Felipe Contreras wrote:
> On Fri, Aug 2, 2013 at 6:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, August 02, 2013 02:37:09 PM Felipe Contreras wrote:
> >> If the _BCL package is descending, the first level (br->levels[2]) will
> >> be 0, and if the number of levels matches the number of steps, we might
> >> confuse a returned level to mean the index.
> >>
> >> For example:
> >>
> >>   current_level = max_level = 100
> >>   test_level = 0
> >>   returned level = 100
> >>
> >> In this case 100 means the level, not the index, and _BCM failed. But if
> >> the _BCL package is descending, the index of level 0 is also 100, so we
> >> assume _BQC is indexed, when it's not.
> >>
> >> This causes all _BQC calls to return bogus values causing weird behavior
> >> from the user's perspective. For example: xbacklight -set 10; xbacklight
> >> -set 20; would flash to 90% and then slowly down to the desired level
> >> (20).
> >>
> >> The solution is simple; test anything other than the first level (e.g.
> >> 1).
> >>
> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> >
> > Looks reasonable.
> >
> > Aaron, what do you think?
> 
> Aaron has a similar patch does many more checks. I think we should add
> more checks, but I think those should go into a separate patch.
> 
> This patch alone fixes a real problem, which is rather urgent to fix,
> and I did it this way so it's trivial to review and merge.

And I still would like to know the Aaron's opinion, what's wrong with that?

