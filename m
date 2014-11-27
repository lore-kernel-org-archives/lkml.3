Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750947AbaK0QsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:48:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:24630 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaK0QsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:48:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="422356226"
Message-ID: <1417106877.5858.133.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/6] UBI: Fastmap: Ensure that all fastmap work is done
 upon WL shutdown
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 27 Nov 2014 18:47:57 +0200
In-Reply-To: <547752D1.6040000@nod.at>
References: <1416835236-25185-1-git-send-email-richard@nod.at>
			 <1416835236-25185-4-git-send-email-richard@nod.at>
		 <1417102739.5858.112.camel@sauron.fi.intel.com> <54774C71.50807@nod.at>
	 <1417105793.5858.117.camel@sauron.fi.intel.com> <547752D1.6040000@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 17:35 +0100, Richard Weinberger wrote:
> Am 27.11.2014 um 17:29 schrieb Artem Bityutskiy:
> > On Thu, 2014-11-27 at 17:08 +0100, Richard Weinberger wrote:
> >>> Obviously, there is some misunderstanding. This looks like lack of
> >>> separation and misuse of layering. I am missing explanations why I am
> >>> wrong...
> >>
> >> So you want me to use the UBI WL background thread for the scheduled fastmap work?
> > 
> > No. It is more like either use it or do not use it.
> 
> Sorry, I don't understand.
> What do you want to do to?

Just keep the code structured. I am just asking questions and trying to
to analyze your patches. If at some point I would like you to do
something specific, I clearly state this. In this case I was complaining
about fastmap specifics in an unrelated file, so basically the wish is
to have it go away. How exactly - not specified, up to you :-) Or, this
means just telling me why it is this way, justify.

When I was working with this code, I did give people specific
suggestions, line-by-line. Now I am more doing more of a sanity check,
looking after the bigger picture.

I understand that this is not a picture of an ideal maintainer, and I am
not anymore an ideal maintainer for this stuff (I think I used to,
though), simply because of lack of time. Doing the best effort job now.

> >> I didn't do it that way because you said more than once that fastmap is fastmap and
> >> WL is WL. Therefore I've separated it.
> > 
> > And "separated" meaning adding this code to wl.c?
> > 
> > +#ifdef CONFIG_MTD_UBI_FASTMAP
> > +       flush_work(&ubi->fm_work);
> > +#endif
> > 
> > Could it be separated some more then?
> > 
> 
> Of course, commit "UBI: Move fastmap specific functions out of wl.c" does.

I did not see it in this series. So you could tell this earlier, not
after 2 e-mail exchanges. Do not assume I remember the details of our
previous discussion. Assume I forgot everything :-)

> But this commit is *bugfix* commit.

I thought adding an close function to fastmap.c is a simple task.

