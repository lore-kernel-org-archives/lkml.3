Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaJIGpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:45:38 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:55562 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbaJIGpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:45:32 -0400
Message-ID: <1412837128.21441.9.camel@x220>
Subject: Re: linux-next: Tree for Oct 8 (media/usb/gspca)
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        linux-media <linux-media@vger.kernel.org>
Date: Thu, 09 Oct 2014 08:45:28 +0200
In-Reply-To: <20141008225011.2d034c1e@recife.lan>
References: <20141008174923.76786a03@canb.auug.org.au>
	 <543570C3.9080207@infradead.org> <20141008153105.2fe82fca@recife.lan>
	 <5435A44D.2050609@infradead.org> <20141008225011.2d034c1e@recife.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2014 06:45:28.0154 (UTC) FILETIME=[9CBC33A0:01CFE38C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-08 at 22:50 -0300, Mauro Carvalho Chehab wrote:
> Em Wed, 08 Oct 2014 13:53:33 -0700
> Randy Dunlap <rdunlap@infradead.org> escreveu:
> > On 10/08/14 11:31, Mauro Carvalho Chehab wrote:
> > > From gpsca's PoV, IMHO, it should be fine to disable the webcam buttons if
> > > the webcam was compiled as builtin and the input subsystem is compiled as 
> > > module. The core feature expected on a camera is to capture streams. 
> > > Buttons are just a plus.
> > > 
> > > Also, most cams don't even have buttons. The gspca subdriver has support 
> > > for buttons for the few models that have it.
> > > 
> > > So, IMHO, it should be ok to have GSPCA=y and INPUT=m, provided that 
> > > the buttons will be disabled.
> > 
> > Then all of the sub-drivers that use IS_ENABLED(CONFIG_INPUT) should be
> > changed to use IS_BUILTIN(CONFIG_INPUT).
> > 
> > But that is too restrictive IMO.  The input subsystem will work fine when
> > CONFIG_INPUT=m and the GSPCA drivers are also loadable modules.
> 
> Agreed.
> 
> Maybe the solution would be something more complex like 
> (for drivers/media/usb/gspca/zc3xx.c):
> 
> #if (IS_BUILTIN(CONFIG_INPUT)) || (IS_ENABLED(CONFIG_INPUT) && !IS_BUILTIN(CONFIG_USB_GSPCA_ZC3XX))

The above discussion meanders a bit, and I just stumbled onto it, but
would
    #if IS_BUILTIN(CONFIG_INPUT) || (IS_MODULE(CONFIG_INPUT) && defined(MODULE))

cover your requirements when using macros?

> Probably the best would be to write another macro that would evaluate
> like the above.


Paul Bolle

