Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaIWHan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:30:43 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36243 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaIWHal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:30:41 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-00-5421219e6975
Message-id: <1411457436.8863.3.camel@AMDC1943>
Subject: Re: [PATCH v6 2/4] amba: Add helper macros for (un)preparing AMBA clock
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Tue, 23 Sep 2014 09:30:36 +0200
In-reply-to: <CAPDyKFpADBgR90_4s6Dxa8GSQ3F2kQFf6Az-J85D_1ZVD6=A5A@mail.gmail.com>
References: <1411379189-3017-1-git-send-email-k.kozlowski@samsung.com>
 <1411379189-3017-3-git-send-email-k.kozlowski@samsung.com>
 <CAPDyKFpADBgR90_4s6Dxa8GSQ3F2kQFf6Az-J85D_1ZVD6=A5A@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t/xK7rzFBVDDBYtELbYOGM9q8X0qRcY
	LVZP/ctqceDPDkaLs01v2C2WTJ7PajFryl4mi4VtS1gsLu+aw2bxufcIo8Xty7wWa4/cZbd4
	9zLC4u6po2wWb+9MZ7E4c/oSq8WE3xfYLI6vDbd42befxUHYo6W5h81j8wotj8V7XjJ53Lm2
	h81jyZtDrB5brrazeMy++4PRo2/LKkaPFau/s3t83iTnsffzb5YA7igum5TUnMyy1CJ9uwSu
	jJYFH5gL2nkqXl/mamA8xtnFyMkhIWAi8f55JxuELSZx4d56IJuLQ0hgKaPEiocvGSGcz4wS
	byYcYgep4hXQkziybQ1TFyMHh7BAgMTzebwgYTYBY4nNy5eADRIR0JDY8/A8K0gvs8AENomn
	O+aygiRYBFQljnWcA7M5BYIlPrb2MEMsOMUo8eHoKkaQBLOAusSkeYuYQRZICChLNPa7QewV
	lPgx+R4LRIm8xOY1b5knMArMQtIxC0nZLCRlCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefn
	bmKEROTXHYxLj1kdYhTgYFTi4fVYoxAixJpYVlyZe4hRgoNZSYR3m4BiiBBvSmJlVWpRfnxR
	aU5q8SFGJg5OqQZGS4HrwZ3SZsviltlcDV0ddXXau+ht8001/P/vruTpTgvweto98xBnTC97
	qZ4n5wwhv0bD6/ocSu0PF3z7IL8oRVz/UJFp2IIFu1MvTw5iD8kXmHGmMDP66vH0N5fFTG5u
	iA1fftGdI23OPqti6aPHf1pIitQ/U558ed1P++kNyk+Nr/2vNzZUYinOSDTUYi4qTgQAyyF3
	FqYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-09-22 at 20:56 +0200, Ulf Hansson wrote:
> On 22 September 2014 11:46, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > Add amba_pclk_prepare() and amba_pclk_unprepare() macros for handling
> > the AMBA bus clock by device drivers.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  include/linux/amba/bus.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> > index fdd7e1b61f60..ad52027a9cbf 100644
> > --- a/include/linux/amba/bus.h
> > +++ b/include/linux/amba/bus.h
> > @@ -92,6 +92,12 @@ void amba_release_regions(struct amba_device *);
> >  #define amba_pclk_disable(d)   \
> >         do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
> >
> > +#define amba_pclk_prepare(d)   \
> > +       (IS_ERR((d)->pclk) ? 0 : clk_prepare((d)->pclk))
> 
> You don't need the IS_ERR, because amba_probe will fail if it won't be
> able to fetch the clock.
> 
> Same comment below.

Right, I followed the convention for amba_pclk_enable but this is not
needed. I'll change it and send new version.

Best regards,
Krzysztof

> 
> Kind regards
> Uffe
> 
> > +
> > +#define amba_pclk_unprepare(d) \
> > +       do { if (!IS_ERR((d)->pclk)) clk_unprepare((d)->pclk); } while (0)
> > +
> >  /* Some drivers don't use the struct amba_device */
> >  #define AMBA_CONFIG_BITS(a) (((a) >> 24) & 0xff)
> >  #define AMBA_REV_BITS(a) (((a) >> 20) & 0x0f)
> > --
> > 1.9.1
> >

