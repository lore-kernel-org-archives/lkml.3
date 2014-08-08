Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbaHHQVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:21:53 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54702 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbaHHQVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:21:51 -0400
Date: Fri, 8 Aug 2014 09:21:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] Input: atmel_mxt_ts - Get IRQ edge/level flags on
 DT booting
Message-ID: <20140808162146.GC26820@core.coreip.homeip.net>
References: <1407397492-17475-1-git-send-email-javier.martinez@collabora.co.uk>
 <53E4D9A5.908@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E4D9A5.908@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 03:07:33PM +0100, Nick Dyer wrote:
> On 07/08/14 08:44, Javier Martinez Canillas wrote:
> > The Atmel maXTouch driver assumed that the IRQ type flags will
> > always be passed using platform data but this is not true when
> > booting using Device Trees. In these setups the interrupt type
> > was ignored by the driver when requesting an IRQ.
> > 
> > This means that it will fail if a machine specified other type
> > than IRQ_TYPE_NONE. The right approach is to get the IRQ flags
> > that was parsed by OF from the "interrupt" Device Tree propery.
> > 
> > Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> I'm happy for this to go in if Dmitry will accept it. It does seem to be a
> quirk of some platforms that it is necessary, but it's only one line.

I'd rather not as it masks the deeper platform issue. There might be
other drovers also expecting platform/OF code set up interrupt triggers
and working/not working by chance.

Can we figure out why the platform in question needs this change?

Thanks.

-- 
Dmitry
