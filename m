Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbaBRMGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:06:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:57484 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbaBRMGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:06:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,501,1389772800"; 
   d="scan'208";a="457357743"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chew, Kean Ho" <kean.ho.chew@intel.com>,
        "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: RE: [PATCH] pwm: add support for Intel Low Power Subsystem PWM
Thread-Topic: [PATCH] pwm: add support for Intel Low Power Subsystem PWM
Thread-Index: AQHPFeODD2mYitjqEkOYVm/Ug18o75qOWl8AgAC154CAAOc8AIArHCbw
Date: Tue, 18 Feb 2014 12:05:35 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA01559812@PGSMSX103.gar.corp.intel.com>
References: <1390240808-18582-1-git-send-email-chiau.ee.chew@intel.com>
 <20140120132814.212929bd@alan.etchedpixels.co.uk>
 <20140121085236.GI18029@intel.com> <20140121194338.GA12085@ulmo.nvidia.com>
 <20140122093116.GR18029@intel.com>
In-Reply-To: <20140122093116.GR18029@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> Sent: Wednesday, January 22, 2014 5:31 PM
> To: Thierry Reding
> Cc: One Thousand Gnomes; Chew, Chiau Ee; linux-pwm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Chew, Kean Ho; Chang, Rebecca Swee Fun
> Subject: Re: [PATCH] pwm: add support for Intel Low Power Subsystem PWM
> 
> On Tue, Jan 21, 2014 at 08:43:39PM +0100, Thierry Reding wrote:
> > The idea behind this is that only a single user can have access to a
> > given PWM device at a time. The PWM device's PWMF_REQUESTED flag is
> > set (and cleared) under the pwm_lock and any subsequent users will not
> > be able to use that specific device (pwm_request() return -EBUSY).
> >
> > There is obviously an assumption here that each user knows what they
> > are doing and aren't calling any of the public pwm_*() functions
> > concurrently. I haven't come across a situation where this is actually
> > a problem because typically these functions are called either via
> > sysfs or some other higher-level where synchronization is already
> > properly handled.
> >
> > So the only thing that drivers should be taking care of is
> > synchronizing access to registers common to multiple PWM devices.
> 
> OK, and since LPSS PWM don't share registers we shouldn't need to do anything
> here.
> 
> > Does that clarify things?
> 
> It does for me, thanks for the explanation.

Hi Thierry,

Would like to find out whether this pwm patch ready to get accepted into mainline kernel? Didn't mean to be pushy :).
Btw, in order to have the Intel Baytrail PWM controller working, it has dependency on the acpi_lpss.c which I have sent the patch (https://lkml.org/lkml/2014/2/18/127) for upstream as well and cc you in the loop. 

Thanks,
Chiau Ee
