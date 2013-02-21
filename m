Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3BUVJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:09:46 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58158 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3BUVJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:09:43 -0500
Date: Thu, 21 Feb 2013 13:09:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, Dudley Du <dudl@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>
Subject: Re: [PATCH] Input: fix Cypress PS/2 Trackpad in Dell XPS12
Message-ID: <20130221210939.GB20344@core.coreip.homeip.net>
References: <1361472955-16759-1-git-send-email-kamal@canonical.com>
 <20130221195630.GA20344@core.coreip.homeip.net>
 <1361476966.3827.44.camel@fourier>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361476966.3827.44.camel@fourier>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 12:02:46PM -0800, Kamal Mostafa wrote:
> On Thu, 2013-02-21 at 11:56 -0800, Dmitry Torokhov wrote:
> > On Thu, Feb 21, 2013 at 10:55:55AM -0800, Kamal Mostafa wrote:
> > > Avoid firmware glitch in Cypress PS/2 Trackpad firmware version 11
> > > (as observed in Dell XPS12) which prevents driver from recognizing
> > > the trackpad.
> > > 
> > > BugLink: http://launchpad.net/bugs/1103594
> > > 
> > > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> > > Cc: Dudley Du <dudl@cypress.com>
> > > ---
> > >  drivers/input/mouse/cypress_ps2.c |   19 +++++++++++++------
> > >  1 file changed, 13 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
> > > index 1673dc6..f51765f 100644
> > > --- a/drivers/input/mouse/cypress_ps2.c
> > > +++ b/drivers/input/mouse/cypress_ps2.c
> > > @@ -236,6 +236,13 @@ static int cypress_read_fw_version(struct psmouse *psmouse)
> > >  	cytp->fw_version = param[2] & FW_VERSION_MASX;
> > >  	cytp->tp_metrics_supported = (param[2] & TP_METRICS_MASK) ? 1 : 0;
> > >  
> > > +	/*
> > > +	 * Trackpad fw_version 11 (in Dell XPS12) yields a bogus response to
> > > +	 * CYTP_CMD_READ_TP_METRICS so do not try to use it. LP: #1103594.
> > > +	 */
> > > +	if (cytp->fw_version >= 11)
> > > +		cytp->tp_metrics_supported = 0;
> > > +
> > 
> > Isn't this the only chunk that is actually needed to fix the issue?
> 
> No, the other parts are needed also:  The handling of
> tp_metrics_supported gets moved so that the default values now get set
> first, then overridden only if tp_metrics_supported is true.
> Previously, the defaults wouldn't get set if it wasn't true (which was a
> bug that never manifested).

OK, fair enough.

BTW, can you tell me what server you published your PGP key to? It does
not seem to be present on the usual ones...

Thanks,
Dmitry

-- 
Dmitry
