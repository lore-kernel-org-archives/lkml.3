Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaJCQU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:20:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:17689 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbaJCQU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:20:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,648,1406617200"; 
   d="scan'208";a="600364224"
Message-ID: <1412353168.10105.5.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Fri, 03 Oct 2014 19:19:28 +0300
In-Reply-To: <CACna6ryws=d_7NXhzWyu34TaV+Yv8y0+D4Q0ewuzDEv=8xDxRg@mail.gmail.com>
References: <1412089998-18978-1-git-send-email-tlinder@codeaurora.org>
	 <1412350035.3795.101.camel@sauron.fi.intel.com>
	 <CACna6ryws=d_7NXhzWyu34TaV+Yv8y0+D4Q0ewuzDEv=8xDxRg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 17:50 +0200, Rafał Miłecki wrote:
> On 3 October 2014 17:27, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > Yes, I guess a single patch is indeed OK. I have few nit-picks, though.
> >
> > On Tue, 2014-09-30 at 18:13 +0300, Tanya Brokhman wrote:
> >> -             ubi_err("'ubi_io_read_ec_hdr()' returned unknown code %d", err);
> >> +             ubi_err(ubi,
> >> +               "'ubi_io_read_ec_hdr()' returned unknown code %d", err);
> >>               return -EINVAL;
> >
> > I think it is fine if the line is long in these cases, let's keep the
> > message on the same line, this split does not contribute to better
> > readability, quite the opposite, in my opinion.
> >
> > One line:
> > ubi_err(ubi, "long line")
> >
> > Multiple lines:
> > ubi_err(ubi, "long line,
> >         parameters)
> 
> You should discuss that with checkpatch team, because ARAIR it will
> complain about "long line" with any other parameter in the same line.

I respect checkpatch.pl, and uniformity / consistency, but in this
particular case I put my maintainer hat on and say that for this kernel
subsystem it is fine, because the maintainer will be more efficient in
maintaining this code when the code is a bit mere readable for him.

Artem.

