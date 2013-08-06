Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3HFJpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:45:49 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:33479 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755488Ab3HFJpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:45:47 -0400
Subject: Re: [PATCH 1/5] pdev: Fix platform device resource linking
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130806093601.GB27889@kroah.com>
Date: Tue, 6 Aug 2013 12:45:42 +0300
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt_Coussno?= <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <311C42C3-6544-4058-ABE9-F9FAE72DD5CA@antoniou-consulting.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com> <1375775624-12250-2-git-send-email-panto@antoniou-consulting.com> <20130806093601.GB27889@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Aug 6, 2013, at 12:36 PM, Greg Kroah-Hartman wrote:

> On Tue, Aug 06, 2013 at 10:53:40AM +0300, Pantelis Antoniou wrote:
>> Platform device removal uncovered a number of problems with
>> the way resources are handled in the core platform code.
>> 
>> Resources now form child/parent linkages and this requires
>> proper linking of the resources. On top of that the OF core
>> directly creates it's own platform devices. Simplify things
>> by providing helper functions that manage the linking properly.
> 
> Ugh, the OF core shouldn't be creating platform devices.  Well, yes, I
> know it does that today, but ick, ick, ick.
> 

Yep, ick, ick, ick is the correct form.

>> Two functions are provided:
>> 
>> platform_device_link_resources(), which links all the
>> linkable resources (if not already linked).
>> 
>> and platform_device_unlink_resources(), which unlinks all the
>> resources.
> 
> Why would anyone need to call this?  I'm getting the feeling that OF
> should just have it's own bus of devices to handle this type of mess.
> ACPI is going through the same rewrite for this same type of problem
> (they did things differently.)  I suggest you work with the ACPI
> developers to so the same thing they are, to solve it correctly for
> everyone.
> 

It's the same problem really. Another bus type might not fly well.
The same device driver should be (in theory) be made to work unchanged
either on an OF/ACPI/Fex( :) ) setup.

What would it take to move all this into driver core?

> thanks,
> 
> greg k-h

Regards

-- Pantelis

