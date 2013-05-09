Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3EIO2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:28:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3EIO2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:28:49 -0400
Date: Thu, 9 May 2013 16:28:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Anthony Olech <Anthony.Olech@diasemi.com>
cc: Krystian Garbaciak <Krystian.Garbaciak@diasemi.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: RE: [RFC PATCH 2/8] regulator: Add Dialog DA906x voltage regulators
 support.
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB514192495F@NB-EX-MBX02.diasemi.com>
Message-ID: <Pine.LNX.4.64.1305091623050.22179@axis700.grange>
References: <201208241450@sw-eng-lt-dc-vm2> <201208241455@sw-eng-lt-dc-vm2>
 <20120825151020.GB6520@opensource.wolfsonmicro.com> <201208291550@sw-eng-lt-dc-vm2>
 <20120830174738.GH4356@opensource.wolfsonmicro.com> <201208311100@sw-eng-lt-dc-vm2>
 <Pine.LNX.4.64.1305091549300.22179@axis700.grange>
 <24DF37198A1E704D9811D8F72B87EB514192495F@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:fkEU5vwL/nfL6c4OUTA2p/ZR9AHVBUA3Ha/H9CbUBAk
 9aXj5eW5nB0L6QjAP1v7GuMf75iikAEuxfEOtZkv1mBRJrZPuI
 hsRDAkOZsd1YYjral0nxSzMkp6TvaknyR9eJ4t83BlYfYJlN9X
 k2LEWuQvDyRegvwBuMEhjT48jL/LKnQOh7MqvSj+Bxyup62obi
 p87gbIMdYBM12+X2+Z5f1YxPdBwxTNE+YQBqtmbvmcQIzwwbr0
 qvn214xfTlCyAyT9A++2YkdehdmYC7sEUIb1zkfcwaCkHIHz3E
 xImNEVN0METLN4iuPHIDrYPH3PTi9IcwgeW9NsxINH6vZTzuV7
 EDvMrnRPhzSh5xPvyIh3J6pRrU50GCi/B+ZQRNfSAYUPonyMlF
 rvQOGlmXl071g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony

On Thu, 9 May 2013, Anthony Olech wrote:

> Hi Guennadi Liakhovetski,
> 
> Now that Krystian no longer works for Dialog I think that I might be 
> your best contact.
> As far as I am aware without doing any checking, the DA906x driver 
> should possibly cover the DA9063.

Good!

> If you need a driver, that would imply that you have some chips. Have 
> you tried our marketting department?

Yes, this (and a da9210) PMICs are used on one of the boards, I'm working 
with. I asked your marketing department for a da9210 datasheet, they tried 
to check with the board vendor, who is also my customer for this project, 
and so far they haven't been able to establish my involvement in this 
development. Have you also got a da9210 Linux driver? Do I have to wait 
for your marketing department clarifying my affiliation or could you make 
that driver available to me too? Or do you mean you might have a newer 
version of this driver available internally too?

Thanks
Guennadi

> Best regards,
> 
> Tony Olech
> 
> 
> > -----Original Message-----
> > From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> > Sent: 09 May 2013 15:06
> > To: Krystian Garbaciak
> > Cc: Mark Brown; linux-kernel@vger.kernel.org; Samuel Ortiz; Alessandro
> > Zummo; Jean Delvare; Dmitry Torokhov; Richard Purdie; Anthony Olech
> > Subject: Re: [RFC PATCH 2/8] regulator: Add Dialog DA906x voltage regulators
> > support.
> > 
> > (trimmed the CC a bit)
> > 
> > Hi Krystian
> > 
> > On Fri, 31 Aug 2012, Krystian Garbaciak wrote:
> > 
> > > > On Wed, Aug 29, 2012 at 03:50:00PM +0100, Krystian Garbaciak wrote:
> > 
> > Sorry for picking up a random mail from this old thread, unfortunately, I don't
> > have "0/8" in my archive.
> > 
> > I have to write a driver for the da9063 PMIC. Do you have an idea, whether it'd
> > be compatible with this driver? Do you plan to continue your work on this driver
> > or would you mind if I try to use these your patches and mainline them,
> > preserving your authorship and copyright, of course?
> > 
> > Thanks
> > Guennadi
> > 
> > > > > Because, for some regulators, this is required: val +=
> > > > > fvol->offset, I was only able to reduce it to the following form.
> > > >
> > > > What on earth makes you say this?  The above is obviously linear.
> > > >
> > > > Besides, you're missing several points here.  One is that you should
> > > > be using the framework features, another is that you should be
> > > > implementing _sel.
> > >
> > > Sorry, I've missed an obvious thing here. Instead of adding selector
> > > offset at runtime, I can substract apropriate voltage from .min_uV.
> > > Thanks for pointing this out.
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > >
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer http://www.open-technology.de/
> Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
> some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
> is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
> copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
> 
> Please consider the environment before printing this e-mail
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
