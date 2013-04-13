Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3DMVoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 17:44:10 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:37348 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab3DMVoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 17:44:08 -0400
Date: Sun, 14 Apr 2013 00:44:00 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Jake Edge <jake@lwn.net>
Cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roberto Oppedisano <roberto.oppedisano@gmail.com>,
        Salvatore Sisinni <s.sisinni@gmail.com>, auxsvr@gmail.com
Subject: Re: still in 3.9-rc6 - fan speed at 100% after suspend/resume
 regression
Message-ID: <20130413214359.GG25821@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Jake Edge <jake@lwn.net>, Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Eduardo Valentin <eduardo.valentin@ti.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Roberto Oppedisano <roberto.oppedisano@gmail.com>,
	Salvatore Sisinni <s.sisinni@gmail.com>, auxsvr@gmail.com
References: <20130413100221.70c040fa@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130413100221.70c040fa@chukar.edge2.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 10:02:21AM -0600, Jake Edge wrote:
> Hi Zhang Rui,
> 
> The problem reported in https://lkml.org/lkml/2012/12/4/428 (and
> incorrectly attributed to a suspend patch by me here:
> https://lkml.org/lkml/2013/4/12/314) still exists in 3.9-rc6, at least
> for my HP/Compaq 2510p laptop. It appeared that some folks were seeing
> some improvement with earlier 3.9-rcs (?) but I just tested rc6 and saw
> substantially the same behavior.  This all works fine in <= 3.6.11.
> 
> A brief recap: after resuming, the fan on the laptop spins up to full
> speed and stays there. "temp6" in "acpitz-virtual-0" (as shown by
> "sensors") is 100°C and stays there, which is presumably what is making
> the fan stay on.

My HP Compaq NC6000 exhibits slightly different behaviour. For me the
reported temp is always accurate but the trip points get out of sync
with the actual temperature.

With 3.7 I saw two different kinds of problems coming out of resume.
In one case the fan stays on until the temp rises high enough to get the
trip points back into sync. In the other case the fan goes off, and stays
off even when the temperature rises above the highest active trip point,
but it does appear to get back into sync when the temp starts to come back
down. I think the difference might stem from resuming when the laptop has
cooled down fully vs. when it's still warm.

I also just tried 3.9-rc6, and that one appears to behave differently
to 3.7, but still wrong. There the fan goes off after resume, and comes
back on as the temperature rises, but it never slows back down after
that.

I'll try to collect some more detailed dumps of all three cases.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
