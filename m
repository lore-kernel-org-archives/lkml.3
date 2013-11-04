Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3KDQUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:20:05 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:38232 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3KDQUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:20:03 -0500
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <20131030173521.GB20147@kroah.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131030173521.GB20147@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 04 Nov 2013 17:18:39 +0100
Message-ID: <1383581919.15642.6.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110416-4966-0000-0000-000007648C65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Mittwoch, den 30.10.2013, 10:35 -0700 schrieb Greg KH:
> Don't let the user pick this, it's up to the driver to set this once
> and
> then live with it.

Ok. I will remove it in the next version.

> 
> And, from what I can tell in the driver, this help text is wrong
> (there
> are no device nodes with this name in it, right?) 

There is a /dev/genwqe<n>_card character device:

card_dev.c:
cd->dev = device_create(cd->class_genwqe, &cd->pci_dev->dev,
				cd->devnum_genwqe, NULL,
				GENWQE_DEVNAME "%u_card", cd->card_idx);

That is what I meant with "device node".

Regards

Frank

