Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaJHUck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:32:40 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53524 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaJHUci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:32:38 -0400
Date: Wed, 8 Oct 2014 13:32:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/4] Input: pmic8xxx-keypad - use regmap_field for
 register access
Message-ID: <20141008203233.GA15198@dtor-ws>
References: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>
 <1412675448-11990-3-git-send-email-iivanov@mm-sol.com>
 <20141007172606.GG16469@dtor-ws>
 <1412759584.13569.0.camel@iivanov-dev>
 <1412760633.13569.4.camel@iivanov-dev>
 <54357BA7.3010609@codeaurora.org>
 <20141008181314.GC14423@dtor-ws>
 <5435808A.7070203@codeaurora.org>
 <20141008200426.GJ4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008200426.GJ4609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 09:04:26PM +0100, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 11:20:58AM -0700, Stephen Boyd wrote:
> > On 10/08/2014 11:13 AM, Dmitry Torokhov wrote:
> 
> > >>>Oops. struct regmap_field is opaque. It seems that the allocation
> > >>>is the only way that I could have instance of it.
> 
> > >>Maybe we can add an API to allocate an array of fields?
> 
> > >Maybe we could make the structure public instead? I do not see any
> > >reason for allocating something separately that has exactly the same
> > >lifetime as owning structure.
> 
> The lifetime may be different to that of the register map it references,
> consider MFD function devices for example.  

Exactly, it is different than lifetime of the register map, but the same
as device structure of the driver instantiating it. And so instead of
doing 10+ separate allocations one could do just one.

> 
> > Srini/Mark, any reason why the regmap_field structure is opaque?
> 
> So you can't peer into it and rely on the contents.  I can see it being
> useful to add a bulk allocator.

And then one have to define offsets in an array and use awkward syntax
to access individual fields. Can we just reply on reviews/documentation
for users to not do wrong thing?

Thanks.

-- 
Dmitry
