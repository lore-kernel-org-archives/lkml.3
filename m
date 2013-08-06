Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3HFVVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:21:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36782 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755125Ab3HFVVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:21:37 -0400
Date: Tue, 6 Aug 2013 17:21:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Shuah Khan <shuah.kh@samsung.com>
cc: "rjw@sisk.pl" <rjw@sisk.pl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sl811h_suspend() and PM_EVENT_PRETHAW state handling
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6175A4F7@sisaex02sj>
Message-ID: <Pine.LNX.4.44L0.1308061719440.930-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Aug 2013, Shuah Khan wrote:

> With the dev_pm_ops model, drivers have to provide interfaces for each 
> one of these states.

No, they don't.  They can leave out interfaces if they want.

>  In this case, there will be a conflict since 
> pm_op() treats this state as freeze where as the driver wants to do 
> treat it as a suspend/hibernate. In the case of legacy pm_ops, state is 
> passed in as a parameter and driver could take special action if need 
> be, based on the state, however in dev_pm_ops model, state is not passed 
> in. Instead it is handled with state specific pm_ops interfaces.
> 
> For example, if this driver were to be converted to dev_pm_ops, it would 
> require a freeze interface which will call sl811h_bus_suspend(). Once 
> that is done, PM_EVENT_PRETHAW will be mapped to freeze() ops and 
> sl811h_bus_suspend() will be called instead of port_power(sl811, 0);
> 
> What I am getting at is, there is no provision to handle the special 
> case for PM_EVENT_PRETHAW like in the case of this driver when using 
> dev_pm_ops.

Okay.  So what?

Alan Stern

