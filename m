Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbaHATXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 15:23:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaHATXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 15:23:01 -0400
Date: Fri, 1 Aug 2014 12:23:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Aniroop Mathur <aniroop.mathur@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: [Question: Drivers/base/core.c] Why dev->init_name = NULL in
 device_add function ?
Message-ID: <20140801192300.GB16085@kroah.com>
References: <CADYu30_FciG_aTTV4DFNdy+CdRChMYQ7pAGZGambE1F9s=ofYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYu30_FciG_aTTV4DFNdy+CdRChMYQ7pAGZGambE1F9s=ofYQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 10:43:23PM +0530, Aniroop Mathur wrote:
> Dear Mr. Greg Kroah-Hartman and Linux Community,
> Greetings of the day !! :)
> 
> I am Aniroop Mathur working on Linux Kernel for last two years.
> I am stuck at one point and could not find the solution over internet.
> I posted on linuxquestions.org too.
> So I need your help and suggestion for it.
> 
> Can you please help in answering my query as below:
> 
> =====================================================
> In function device_add of /drivers/base/core.c file, it is mentioned:
> /*
> * for statically allocated devices, which should all be converted
> * some day, we need to initialize the name. We prevent reading back
> * the name, and force the use of dev_name()
> */
> if (dev->init_name) {
> dev_set_name(dev, "%s", dev->init_name);
> dev->init_name = NULL;
> }
> 
> 
> Except forcing the use of dev_name to read device name,
> Is there any other reason to make init_name as NULL ?

Why would you want init_name to not be NULL?

> And if it is not made NULL, is there any problem or side-effect ?

Yes, people would start to use it thinking it was the real name of the
device, when it might not be.

greg k-h
