Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaG3NU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:20:27 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34705 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaG3NUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:20:25 -0400
Date: Wed, 30 Jul 2014 09:20:17 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "eduardo.valentin@gmail.com" <eduardo.valentin@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "javi.merino@arm.com" <javi.merino@arm.com>
Subject: Re: [PATCH-REPOST] thermal: of: look for sensor driver parent node
 if device node missing
Message-ID: <20140730132017.GC14219@developer>
References: <1406279971-14957-1-git-send-email-ldewangan@nvidia.com>
 <20140729141234.GA26807@developer>
 <53D7AE7E.8070104@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D7AE7E.8070104@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laxman,

On Tue, Jul 29, 2014 at 07:53:58PM +0530, Laxman Dewangan wrote:
> On Tuesday 29 July 2014 07:42 PM, Eduardo Valentin wrote:
> > Hello Laxman,
> >
> > On Fri, Jul 25, 2014 at 02:49:31PM +0530, Laxman Dewangan wrote:
> >> There are some mfd devices which supports junction thermal interrupt
> >> like ams,AS3722. The DT binding of these devices are defined as the
> >> flat and drivers for sub module of such devices are registered as
> >> the mfd_add_devices. In this method, the sub devices registered as
> >> platform driver and these do not have the of_node pointer on their
> >> device structure. In this case, use the parent of_node pointer to
> >> get the required of_node pointer.
> >>
> > Can you please elaborate a bit more on your proposal? So, you would
> > append the thermal zones on the DT node of the MFD device?
> 
> Yes, mfd node for ams,as3722 is flat node, almost all sub-module driver 
> have their property on this node only. Regulator have their own sub node 
> under this node.
> 
> as3722 {
>          compatible = "ams,as3722";
>          #gpio-contorller;
>          #gpio-cells = <2>;
>      ::::::::::
>          regulator {
>                  ::::
>          };
> };
> 
> 
> So in this, the thermal sensor driver's property is on the as3722 node 
> only and thermal zone need to refer this node for sensor.
> 
> However, as3722 thermal sensor driver is register as sub mfd devices 
> through mfd_add_devices() and thermal sensor drivers pdev->dev.of_node 
> does not have any valid pointer.

In such case, the MFD driver shall populate the required data while
creating the sub device, right?

