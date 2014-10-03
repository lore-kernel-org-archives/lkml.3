Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaJCINS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:13:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:3847 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaJCINM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:13:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,645,1406617200"; 
   d="scan'208";a="582918211"
Date: Fri, 3 Oct 2014 11:12:33 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 04/15] ACPI: Document ACPI device specific properties
Message-ID: <20141003081233.GU1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <15893883.nvuW3ndylz@wuerfel>
 <20141002133654.GP1786@lahna.fi.intel.com>
 <26673925.fa6Qhdm5sV@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26673925.fa6Qhdm5sV@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 04:03:51AM +0200, Rafael J. Wysocki wrote:
> On Thursday, October 02, 2014 04:36:54 PM Mika Westerberg wrote:
> > On Thu, Oct 02, 2014 at 02:46:30PM +0200, Arnd Bergmann wrote:
> > > On Thursday 02 October 2014 15:15:08 Mika Westerberg wrote:
> 
> [cut]
> 
> > 
> > Putting everything to a single package results this:
> > 
> > 		Package () { "pwms", Package () {"led-red", ^PWM0, 0, 10, "led-green", ^PWM0, 1, 10 }}
> > 
> > But I think the below looks better:
> 
> I agree.
> 
> > 		Package () { "pwms", Package () {^PWM0, 0, 10, ^PWM0, 1, 10 }}
> > 		Package () { "pwm-names", Package () {"led-red", "led-green"}}
> > 
> > and it is trivial to match with the corresponding DT fragment.
> > 
> > > 	}
> > > 
> > > vs.
> > > 
> > > 	pwm-slave {
> > > 		pwms = <&pwm0 0 10>, <&pwm1 1 20>;
> > > 		pwm-names = "led-red", "led-green";
> > > 	};
> > > 
> > 
> > I don't have strong feelings which way it should be. The current
> > implementation limits references so that you can have only integer
> > arguments, like {ref0, int, int, ref1, int} but if people think it is
> > better to allow strings there as well, it can be changed.
> > 
> > I would like to get comments from Darren and Rafael about this, though.
> 
> In my opinion there needs to be a "canonical" representation of the
> binding that people always can expect to work.  It seems reasonable to
> use the one exactly matching the DT representation for that.
> 
> In addition to that we can add other representations that the code will
> also parse correctly as alternatives.  In the future.

OK, so if no objections and Arnd promised not to complain too loudly, I
would like to keep this as is for now.
