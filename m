Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3KDQoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:44:10 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:50440 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab3KDQoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:44:09 -0500
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <5271D340.2090706@gmail.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
	 <5271D340.2090706@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 04 Nov 2013 17:44:01 +0100
Message-ID: <1383583441.15642.31.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110416-6892-0000-0000-000006CCCC5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

Am Donnerstag, den 31.10.2013, 14:49 +1100 schrieb Ryan Mallon:
> > +static ssize_t show_card_status(struct device *dev,
> > +                             struct device_attribute *attr,
> > +                             char *buf)
> > +{
> > +     ssize_t len = 0;
> > +     struct genwqe_dev *cd = dev_get_drvdata(dev);
> > +     const char *cs[GENWQE_CARD_STATE_MAX] = { "unused", "used",
> "error" };
> > +
> > +     len += scnprintf(&buf[len], PAGE_SIZE - len,
> > +                      "%s\n", cs[cd->card_state]);
> > +     return len;
> 
> This is a bit confusingly written. Why do:
> 
>         scnprintf(&buf[len], ...
> 
> When len is always zero at that point? Since you are printing from an
> array of statically sized strings that are guaranteed to be smaller
> than
> PAGE_SIZE, you can safely do:
> 
>         sprintf(buf, "%s\n", cs[cd->card_state]);
> 
> You might want to add some checking for cd->card_state being out of
> bounds, and printing "unknown" or something in that case.
> 
> Same issue exists in other sysfs handlers.
> 

I kept using scnprintf(), but reworked the code around it. ssize_t len
is not needed of course and the &buf[len] stuff is obsolete too. I had
sysfs entries with multiple lines of output, where it was convenient and
safe to code it like that. Now since those interfaces were moved to
debugfs, the sysfs code can be simpler, as you pointed it out.

Regards

Frank

