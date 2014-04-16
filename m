Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbaDPVJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:09:47 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37560 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751925AbaDPVJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:09:45 -0400
Date: Wed, 16 Apr 2014 22:09:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH RFC] PM / Hibernate: no kernel_power_off when
	pm_power_off NULL
Message-ID: <20140416210901.GK24070@n2100.arm.linux.org.uk>
References: <20140320212336.GA17368@amd.pavel.ucw.cz> <20140320213502.795a5d3c@alan.etchedpixels.co.uk> <CADHgK6uXg0CXZC5s5Z5Kpy6dYH58UChL-p9ozCCcoUU=-0KJYw@mail.gmail.com> <CADHgK6sh6TUc4jBQFQHTQuhze9=r2FBzF6aULUc_c+bbWYjp5w@mail.gmail.com> <CADHgK6sCmPVZ--eyEnqnjfs_4C_PfHTgAUQ_Nb4oJP0mBDnQUw@mail.gmail.com> <20140415205453.GX24070@n2100.arm.linux.org.uk> <20140415211832.GA32213@amd.pavel.ucw.cz> <CADHgK6vzagyELYGnVoHvfnK9G57-NSycOaKsNQ53rnU1pOwn=Q@mail.gmail.com> <20140416204119.GJ24070@n2100.arm.linux.org.uk> <20140416215718.7f58efd8@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416215718.7f58efd8@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 09:57:18PM +0100, One Thousand Gnomes wrote:
> > I'd say scrap (a) _unless_ we're going to add while (1) loops to all
> > the architectures.  Alternatively, we could just accept that
> > machine_power_off() may return and deal with that case (iow, not
> > crash) in generic code.
> 
> What would the right behaviour be
> 
> while(1);
> 
> isn't really nice behaviour on a modern device 

That's an entirely different question... one which also needs fixing
in the hibernate code.  We already know that cpu_relax() in there is
a good thing to do, so that would be a good start.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
