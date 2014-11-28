Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaK1LzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:55:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:14448 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaK1LzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:55:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,476,1413270000"; 
   d="scan'208";a="639525107"
Date: Fri, 28 Nov 2014 13:54:57 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Darren Hart <dvhart@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Alex Hung <alex.hung@canonical.com>
Subject: Re: [PATCH 1/3] platform: x86: dell-rbtn: Dell Airplane Mode Switch
 driver
Message-ID: <20141128115457.GT1304@lahna.fi.intel.com>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
 <1416755361-17357-2-git-send-email-pali.rohar@gmail.com>
 <20141128113328.GS1304@lahna.fi.intel.com>
 <201411281245.55747@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201411281245.55747@pali>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 12:45:55PM +0100, Pali Rohár wrote:
> Hello,
> 
> I will fix all those style problems and add some comments.
> 
> On Friday 28 November 2014 12:33:28 Mika Westerberg wrote:
> > > +	if (ACPI_FAILURE(status))
> > > +		return;
> > > +
> > > +	rfkill_set_states(rfkill, !output, !output);
> > 
> > You can also write it like:
> > 
> > 	if (ACPI_SUCCESS(status))
> > 		rfkill_set_states(rfkill, !output, !output);
> > 
> > which looks better to me at least.
> > 
> 
> In whole module I'm using this style:
> 
> f1();
> if (f1_failed)
> 	return;
> f2()
> if (f2_failed)
> 	return;
> 
> So I would like not to change it for one function.

Fair enough.

> > > +}
> > > +
> > > +static int rbtn_set_block(void *data, bool blocked)
> > > +{
> > > +	/* FIXME: setting soft rfkill cause problems, so disable
> > > it for now */ +	return -EINVAL;
> > > +}
> > > +
> > > +struct rfkill_ops rbtn_ops = {
> > 
> > static? const?
> > 
> 
> Yes, static const should be used.
> 
> > 
> > > +/*** module functions ***/
> > > +
> > > +static int __init rbtn_init(void)
> > > +{
> > > +	return acpi_bus_register_driver(&rbtn_driver);
> > > +}
> > > +
> > > +static void __exit rbtn_exit(void)
> > > +{
> > > +	acpi_bus_unregister_driver(&rbtn_driver);
> > > +}
> > > +
> > > +module_init(rbtn_init);
> > > +module_exit(rbtn_exit);
> > 
> > module_acpi_driver()?
> > 
> 
> No, see PATCH 2/3.

Yeah, I noticed it after I wrote the comment.
