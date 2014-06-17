Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaFQF4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:56:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43978 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaFQF4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:56:13 -0400
Date: Tue, 17 Jun 2014 08:56:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Monam Agarwal <monamagarwal123@gmail.com>
Subject: Re: [PATCH] staging: ced1401: userspace: use1401.c: Cleaning up
 potential strncpy missing null-terminate
Message-ID: <20140617055609.GK5500@mwanda>
References: <1402785707-12383-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1402785707-12383-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140616190114.GI5500@mwanda>
 <20140616190933.GJ5500@mwanda>
 <CAFo99gaUmL1_BYeWSBnzpDFWOoJKmmvhG_wVw-5F9fj-7EpufA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gaUmL1_BYeWSBnzpDFWOoJKmmvhG_wVw-5F9fj-7EpufA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 12:14:18AM +0200, Rickard Strandqvist wrote:
> 2014-06-16 21:09 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> > On Mon, Jun 16, 2014 at 10:01:14PM +0300, Dan Carpenter wrote:
> >>
> >> No one calls U14DriverName() so just delete this function.
> >
> > Oh.  This is a userspace library or something?  I'm not sure what to do.
> >
> > How did you compile test this?  Does your platform even provide
> > strlcpy()?
> >
> > Anyway, don't delete it like I said, but I still don't think your patch
> > helps here.
> >
> > regards,
> > dan carpenter
> >
> 
> Hi
> 
> I saw that these functions are not used, had planned type it in the
> cover letter to :-(
> 
> Thought of userspec, but then it should definitely ensure the NULL char?

The strings are always 4 characters long.  If the user start passing 3
character buffers then it will *never* work.  That means the bug will be
caught on the first run in testing.

I don't worry about those kinds of bugs very much.  It's only a concern
if it works 99 times and fails 1 time.

regards,
dan carpenter
