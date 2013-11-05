Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3KEHQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:16:33 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:45917 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3KEHQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:16:31 -0500
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <20131104221524.GD14141@kroah.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131030174403.GF20147@kroah.com>
	 <1383583287.15642.29.camel@oc7383187364.ibm.com>
	 <20131104221524.GD14141@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 05 Nov 2013 08:16:24 +0100
Message-ID: <1383635784.11383.2.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110507-3548-0000-0000-0000070BD035
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Montag, den 04.11.2013, 14:15 -0800 schrieb Greg KH:
> > I am using sysfs_create_group() now, but do I understand you
> correctly
> > that setting the const struct attribute_group **groups; in my device
> > (where in my struct pci_device.dev?) is an even better way to
> establish
> > my sysfs attributes? Is there a function which I could call rather
> than
> > trying to find the right pointer?
> 
> Ugh, this is still a problem, I'm trying to work through how to have
> individual drivers implement groups and sysfs files in a non-racy way.
> The issue is your device was announced to userspace _before_ it was
> bound to the driver, so there's no way to get the sysfs files to apply
> before then.
> 
> You should just have the attributes on the sysfs device you create
> yourself, not your pci device, as that's where they make more sense,
> and
> there you should be able to use the attribute group easily, right?
> 

The current version works well for me and I did not get any complaints
about the possible race-condition you mentioned so far. So I am happy.

> thanks,
> 
> greg k-h

Greetings

Frank

