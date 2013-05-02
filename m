Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761669Ab3EBV6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:58:37 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:64930 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3EBV6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:58:35 -0400
Date: Thu, 2 May 2013 14:58:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@infradead.org>
cc: Simon Wood <simon@mungewell.org>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-steelseries fix led class build issue
In-Reply-To: <5182DFA3.3040707@infradead.org>
Message-ID: <alpine.DEB.2.02.1305021455260.941@chino.kir.corp.google.com>
References: <51816271.3040400@infradead.org> <1367476041-25760-1-git-send-email-simon@mungewell.org> <5182DFA3.3040707@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Randy Dunlap wrote:

> > ---
> >  drivers/hid/hid-steelseries.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-steelseries.c b/drivers/hid/hid-steelseries.c
> > index 2ed995c..dbd5e2e 100644
> > --- a/drivers/hid/hid-steelseries.c
> > +++ b/drivers/hid/hid-steelseries.c
> > @@ -19,7 +19,8 @@
> >  #include "usbhid/usbhid.h"
> >  #include "hid-ids.h"
> >  
> > -#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
> > +#if defined(CONFIG_LEDS_CLASS) || \
> > +    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_HID_STEELSERIES_MODULE))
> >  #define SRWS1_NUMBER_LEDS 15
> >  struct steelseries_srws1_data {
> >  	__u16 led_state;

While we're working on getting a signed-off-by line, the clean way of 
handling this is

#if IS_BUILTIN(CONFIG_LEDS_CLASS) || \
    (IS_MODULE(CONFIG_LEDS_CLASS) && IS_MODULE(CONFIG_HID_STEELSERIES))
