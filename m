Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaJTLWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:22:32 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53096 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbaJTLW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:22:27 -0400
Message-ID: <1413804158.13490.6.camel@mm-sol.com>
Subject: Re: [PATCH] iio: inkern: Add of_xlate function to struct iio_dev
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>, linux-iio@vger.kernel.org,
        svarbanov@mm-sol.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Mon, 20 Oct 2014 14:22:38 +0300
In-Reply-To: <54425998.7060808@kernel.org>
References: <1412253128-32165-1-git-send-email-iivanov@mm-sol.com>
	 <5442522D.40203@kernel.org> <544253F3.9060002@metafoo.de>
	 <54425998.7060808@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.5-fta1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2014-10-18 at 13:14 +0100, Jonathan Cameron wrote:
> On 18/10/14 12:50, Lars-Peter Clausen wrote:
> >  On 10/18/2014 01:42 PM, Jonathan Cameron wrote:
> > >  On 02/10/14 13:32, Ivan T. Ivanov wrote:
> > > >  When #iio-cells is greater than '0', the driver could provide
> > > >  a custom of_xlate function that reads the *args* and returns
> > > >  the appropriate index in registered IIO channels array.
> > > > >
> > > >  Add simple translation function, suitable for the most 1:1
> > > >  mapped channels in IIO chips, and use it when driver did not
> > > >  provide custom implementation.
> > > > >
> > > >  Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > >  Any more comments on this?  Been sat a while and the 
> > > discussions seems
> > >  to have died out.
> > > >
> > >  As Ivan has pointed out, very similar approaches are used
> > >  elsewhere (gpio for example).
> > 
> >  Looks good to me:
> > 
> >  Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
> > 
> >  When we initially added the DT support to IIO I was hoping that 
> > we can get away
> >  with just using the simple and generic xlate function for all 
> > devices. But it
> >  looks as if some more complex devices need to overwrite it. We 
> > should be careful
> >  about adding new driver specific xlate implementations and make 
> > sure that it is
> >  actually needed.
> > 
> >  One thing we might want to consider though is instead of adding 
> > the xlate
> >  callback to the iio_dev struct add it to the iio_info struct 
> > since it should be
> >  the same for different device instances of the same driver. And 
> > this is also
> >  where all the other callbacks are.
> Good point - would definitely prefer that.

Thank you. Will rework it as suggested.

Regards,
Ivan

> 
> J
> > 
> >  - Lars
> 
