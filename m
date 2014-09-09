Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbaIIIuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:50:16 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:49304 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932394AbaIIIuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:50:11 -0400
Message-ID: <1410252608.22255.5.camel@x220>
Subject: Re: [PATCH] eeepc-laptop: remove possible use of uninitialized value
From: Paul Bolle <pebolle@tiscali.nl>
To: Darren Hart <dvhart@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Frans Klaver <fransklaver@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Date: Tue, 09 Sep 2014 10:50:08 +0200
In-Reply-To: <7288841.ayNsq2yeGO@vostro.rjw.lan>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
	 <1409814488.5546.63.camel@x220> <20140906021757.GA9197@vmdeb7>
	 <7288841.ayNsq2yeGO@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2014 08:50:08.0531 (UTC) FILETIME=[0EFEA630:01CFCC0B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

On Sat, 2014-09-06 at 23:17 +0200, Rafael J. Wysocki wrote:
> On Friday, September 05, 2014 07:17:57 PM Darren Hart wrote:
> > On Thu, Sep 04, 2014 at 09:08:08AM +0200, Paul Bolle wrote:
> > [...]
> > >  static ssize_t store_sys_acpi(struct device *dev, int cm,
> > > @@ -278,12 +276,13 @@ static ssize_t store_sys_acpi(struct device *dev, int cm,
> > >  	struct eeepc_laptop *eeepc = dev_get_drvdata(dev);
> > >  	int rv, value;
> > >  
> > > -	rv = parse_arg(buf, count, &value);
> > > -	if (rv > 0)
> > > -		value = set_acpi(eeepc, cm, value);
> > > +	rv = parse_arg(buf, &value);
> > > +	if (rv < 0)
> > > +		return rv;
> > > +	value = set_acpi(eeepc, cm, value);
> > >  	if (value < 0)
> > 
> > I suppose it's harmless, but it would be more explicit to reuse rv here instead
> > of value.

Fine with me.
 
> > >  		return -EIO;
> > 
> > And as with Frans' version, I suggest propogating the error. We're talking about
> > a missing/invalid ACPI control method name here, ENODEV seems approprirate.
> > 
> > Rafael, do you have a strong preference about what to return in such an event?
> 
> No, I don't, although -ENXIO could be used here too.

If you could say what value you'd like best I'll resend using that
value. (I don't know what the effect is of using a specific error here,
so I guess I'll have to bluff about it in the commit explanation.)

Thanks,


Paul Bolle

