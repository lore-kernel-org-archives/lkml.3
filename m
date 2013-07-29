Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3G2GR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:17:26 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56583 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab3G2GRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:17:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAKDJKT6UETVpPT9B6LE59_EMrxNGpTmUiu9iddHoWOYhGpHP3Q@mail.gmail.com>
References: <1369126458-24872-1-git-send-email-manishv.b@ti.com>
	<1369126458-24872-2-git-send-email-manishv.b@ti.com>
	<20130610060442.GA30158@core.coreip.homeip.net>
	<A4887BF146CD57468F700B415D2F47015A0DFD@DBDE04.ent.ti.com>
	<20130610180311.GA4649@core.coreip.homeip.net>
	<A4887BF146CD57468F700B415D2F47015A1315@DBDE04.ent.ti.com>
	<CAKDJKT6UETVpPT9B6LE59_EMrxNGpTmUiu9iddHoWOYhGpHP3Q@mail.gmail.com>
Date: Mon, 29 Jul 2013 11:47:21 +0530
Message-ID: <CAKDJKT500ewMEv-f-vZBkMELkFkNBXLrv0oS_qUivbq0T-Y6yA@mail.gmail.com>
Subject: Re: [PATCH V3 1/2] tps6507x-ts: Add DT support
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob@landley.net" <rob@landley.net>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry

On Mon, Jul 1, 2013 at 4:40 PM, Manish Badarkhe
<badarkhe.manish@gmail.com> wrote:
>
> Hi Dmitry
>
>
> On Wed, Jun 12, 2013 at 12:23 PM, Vishwanathrao Badarkhe, Manish
> <manishv.b@ti.com> wrote:
> > Hi Dmitry,
> >
> > On Mon, Jun 10, 2013 at 23:33:11, Dmitry Torokhov wrote:
> >> Manish,
> >>
> >> On Mon, Jun 10, 2013 at 10:23:16AM +0000, Vishwanathrao Badarkhe,
> >> Manish wrote:
> >> > Hi Dmitry,
> >> >
> >> > On Mon, Jun 10, 2013 at 11:34:42, Dmitry Torokhov wrote:
> >> > > Hi Manish,
> >> > >
> >> > > On Tue, May 21, 2013 at 02:24:17PM +0530, Vishwanathrao Badarkhe,
> >> > > Manish wrote:
> >> > >
> >> > > > +       struct touchscreen_init_data *init_data = NULL;
> >> > > > +       int err;
> >> > > > +
> >> > > > +       if (node)
> >> > > > +               node = of_find_node_by_name(node, "tsc");
> >> > >
> >> > > Why do you have to locate OF node manually instead of already
> >> > > having it attached to the device stucture?
> >> >
> >> > As TPS6507x is mfd device containing two nodes, regulator and
> >> > touchscreen.
> >> > It is necessary to use "of_find_node_by_name" to find child "tsc"
> >> > node
> >> > of TPS6507x MFD device.
> >>
> >> I understand that TPS6507x is a MFD device, However, I still do not
> >> understand why you do not attach OF data to the child platform device
> >> representing touch screen when you create it.
> >
> > I gone through most of MFD devices in mainline kernel where
> > "of_find_node_by_name"
> > function is used in order to populate child node properties.
> > See below example of max8925 MFD device.
> >
> > Max8025 MFD device has following modules
> > 1. Touch screen
> > 2. Charger
> > 3. Backlight
> > 4. regulator
> >
> > In DT case, device node for max8925 MFD device is in
> > "arch/arm/boot/dts/mmp2-brownstone.dts"
> > file having child nodes as regulator, backlight and charger.
> > Respective drivers (regulator, backlight and charger) of max8925 MFD
> > device used
> > "of_find_node_by_name" function in order to populate child node
> > properties.
> >
> > Here, also same case for TPS6507x MFD device
> >
> > TPS6507x MFD device has two childs:
> > 1. regulator
> > 2. touch screen.
> >
> > Regulator driver for TPS6507x is already in mainline and using function
> > "of_find_node_by_name" to populate device tree properties for
> > regulators.
> > On similar lines I used "of_find_node_by_name" to populate device
> > tree properties for touch screen.
> >
> > Still, I agreed that it is possible to attach OF data to child platform
> > device
> > but it requires changes in MFD driver of TPS6507x.
> >
> > Please let me know your opinion about this.
>
> Please let me know so accordingly I will make changes in code.
>

Please provide your comments so accordingly will make changes in code.

Regards
Manish Badarkhe
