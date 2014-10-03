Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaJCN6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:58:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64620 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469AbaJCN6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:58:31 -0400
Date: Fri, 3 Oct 2014 14:58:26 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 04/15] ACPI: Document ACPI device specific properties
Message-ID: <20141003135826.GN26643@leverpostej>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <15893883.nvuW3ndylz@wuerfel>
 <20141002133654.GP1786@lahna.fi.intel.com>
 <26673925.fa6Qhdm5sV@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26673925.fa6Qhdm5sV@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 03:03:51AM +0100, Rafael J. Wysocki wrote:
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

I don't follow. The two forms would share the same high-level accessors,
but the binary representation is already different. Why should we choose
the inferior layout given they are already different binary formats?

Mark.
