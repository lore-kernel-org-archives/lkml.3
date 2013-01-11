Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3AKBvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 20:51:36 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:55679 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab3AKBve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 20:51:34 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6s2UxekcZ1zdYiP_FjgYPhjKzob8HMK-PGN6XD8wBWquA@mail.gmail.com>
References: <1355348028-19017-1-git-send-email-sjg@chromium.org>
	<1355348028-19017-6-git-send-email-sjg@chromium.org>
	<20121215011345.9D5973E0BEE@localhost>
	<2990462.l5jY89jKQx@dtor-d630.eng.vmware.com>
	<20121219125722.DCD3E3E0AD7@localhost>
	<20121219181643.GA31435@core.coreip.homeip.net>
	<CAPnjgZ2MH_iD73oOZe7pEEAVg_8c5dFWHdeaNfD6A4E9NeWRug@mail.gmail.com>
	<CACxGe6s2UxekcZ1zdYiP_FjgYPhjKzob8HMK-PGN6XD8wBWquA@mail.gmail.com>
Date: Thu, 10 Jan 2013 17:51:33 -0800
X-Google-Sender-Auth: zPzwflmgXiG8GaLng7WSq-S9ziQ
Message-ID: <CAPnjgZ315QhvTw9C=MLA=QhGa1Wo572tRN5KyRsNpEJ3Wmq4vg@mail.gmail.com>
Subject: Re: [PATCH 5/5] Input: Add ChromeOS EC keyboard driver
From: Simon Glass <sjg@chromium.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Olof Johansson <olof@lixom.net>, Roland Stigge <stigge@antcom.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Wed, Dec 19, 2012 at 12:42 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Wed, Dec 19, 2012 at 8:20 PM, Simon Glass <sjg@chromium.org> wrote:
>> On Wed, Dec 19, 2012 at 10:16 AM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>>>
>>> On Wed, Dec 19, 2012 at 12:57:22PM +0000, Grant Likely wrote:
>>> > On Fri, 14 Dec 2012 17:43:31 -0800, Dmitry Torokhov
>>> > <dmitry.torokhov@gmail.com> wrote:
>>> > > On Saturday, December 15, 2012 01:13:45 AM Grant Likely wrote:
>>> > > > > +Required properties:
>>> > > > > +- compatible: "google,cros-ec-keyb"
>>> > > > > +- google,key-rows: Number of keyboard rows (must be <= 8)
>>> > > > > +- google,key-columns: Number of keyboard columns (must be <= 13)
>>> > > > > +- google,repeat-delay-ms: Key repeat delay in milliseconds
>>> > > > > +- google,repeat-rate-ms: Key repeat rate in milliseconds
>>> > > >
>>> > > > Hmmm, these should probably be in a common binding. Take a look at
>>> > > > the other input bindings and make a proposal for properties to add
>>> > > > to
>>> > > > matrix-keymap.txt.
>>> > >
>>> > > Actually these are not essentia for bringup and can be set from
>>> > > userspace,
>>> > > so I'd say simply drop them.
>>> >
>>> > Aren't they needed for a working keyboard? If so, I would really think
>>> > they should be set correctly without userspace intervention.
>>>
>>> I am sorry if I was unclear, but I was actually talking about the last
>>> 2: repeat-delay-ms and repeat-rate-ms. Input core has I believe sane
>>> defaults (250 msec delay, 33 cps autorepeat) and user can adjust if
>>> other rate is preferred.
>>
>>
>> I seems like I should remove these two, then.
>>
>> It would be nice if we could keep these parameters so that the keyboard
>> doesn't require user-space set up to work, but I understand and agree they
>> are not essential. Regarding Grant's request to come up with a common
>> binding, if I remove these then that is not needed, right?
>
> I have no problem keeping the properties, but it does look like
> something applicable to all users, not just this driver.

I dropped keyboard repeat from the common binding and resent. If that
goes in then I can try again later when Dmitry is on holiday :-), or I
can put it just in our own driver. I don't mind either way, so someone
should let me know which is best.

>
> g.

Regards,
Simon
