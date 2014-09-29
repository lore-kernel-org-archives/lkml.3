Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaI2QaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:30:17 -0400
Received: from mailsec112.isp.belgacom.be ([195.238.20.108]:31604 "EHLO
	mailsec112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129AbaI2QaP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:30:15 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=QtXKAWzsBkcudMCKpZuGZ7NJaqRtyPzs72kSfj+Kyd4= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8
 a=-rE1qe-bh9ZcCm4xV6AA:9 a=QEXdDO2ut3YA:10 a=x8gzFH9gYPwA:10
 a=MSl-tDqOz04A:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkIRAFuIKVTD7hTR/2dsb2JhbABggw5TV4MBsxcGk3EKh04CgRIWAXsJDoERYoF5AQEBAwEjBCcrBQsFBAIYAgIYDgICIRAmBggLCQgMBIgJAwkMCY0VnEyGf4c9DYcMGIEshGaHXB2BLzEzB4J4gVMFj0uGVIR5g3KNMwOGRYNlOy8BgQUUgTABAQE
Date: Mon, 29 Sep 2014 18:30:13 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org
Message-ID: <1643816105.31300.1412008213769.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140929054004.GA4144@sudip-PC>
References: <1411929887-2440-1-git-send-email-fabf@skynet.be> <20140929054004.GA4144@sudip-PC>
Subject: Re: [PATCH 1/1 linux-next] ACPI / SBS: fix sparse warning
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 29 September 2014 at 07:40 Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> wrote:
>
>
> On Sun, Sep 28, 2014 at 08:44:47PM +0200, Fabian Frederick wrote:
> > Adding parentheses around expression to avoid:
> > drivers/acpi/sbs.c:444:28: warning: dubious: !x & y
> >
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  drivers/acpi/sbs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
> > index 32aecea..a7a3edd 100644
> > --- a/drivers/acpi/sbs.c
> > +++ b/drivers/acpi/sbs.c
> > @@ -441,7 +441,7 @@ static int acpi_ac_get_present(struct acpi_sbs *sbs)
> >      * The spec requires that bit 4 always be 1. If it's not set, assume
> >      * that the implementation doesn't support an SBS charger
> >      */
> > -   if (!(status >> 4) & 0x1)
> > +   if (!((status >> 4) & 0x1))
>
> i think the logic changed over here.
> it was !x & y , but now it has become !(x & y)
> ! is having higher priority than & so !x & y will mean ((!x) & y)
>
> thanks
> sudip
Hello Sudip,

You're right, logic has changed but IMHO expression was wrong.

Let's take value 100, decimal.
Binary: 0110>0<100

Spec states that bit 4 must be 1 so value is wrong.

We don't go in
if (!(status>>4) & 0x1)

but

if (!((status>>4) & 0x1))
        return -ENODEV;

is triggered.

Regards,
Fabian
> >             return -ENODEV;
> > 
> >     sbs->charger_present = (status >> 15) & 0x1;
> > --
> > 1.9.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
