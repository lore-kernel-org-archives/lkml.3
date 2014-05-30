Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaE3Jmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:42:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33411 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755160AbaE3Jmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:42:45 -0400
Date: Fri, 30 May 2014 10:42:43 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] extcon: arizona: Update manual headphone detection
	calculation
Message-ID: <20140530094243.GB11951@opensource.wolfsonmicro.com>
References: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1401377274-10249-3-git-send-email-ckeepax@opensource.wolfsonmicro.com> <5387DE87.5090009@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5387DE87.5090009@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 10:27:35AM +0900, Chanwoo Choi wrote:
> Hi Charles,
> 
> On 05/30/2014 12:27 AM, Charles Keepax wrote:
> > The higher levels of impedance have a higher minimum value than the
> > first level. As the same value was used for all levels, higher impedances
> > were reported with a very low level of accuracy. This patch applies the
> > approriate lower threshold for each level.
> > 
> > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > ---
> >  drivers/extcon/extcon-arizona.c |   13 ++++++++-----
> >  1 files changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> > index f2c36b1..c1c8647 100644
> > --- a/drivers/extcon/extcon-arizona.c
> > +++ b/drivers/extcon/extcon-arizona.c
> > @@ -329,12 +329,13 @@ static void arizona_stop_mic(struct arizona_extcon_info *info)
> >  }
> >  
> >  static struct {
> > +	unsigned int threshold;
> >  	unsigned int factor_a;
> >  	unsigned int factor_b;
> >  } arizona_hpdet_b_ranges[] = {
> > -	{  5528,   362464 },
> > -	{ 11084,  6186851 },
> > -	{ 11065, 65460395 },
> > +	{ 100,  5528,   362464 },
> > +	{ 169, 11084,  6186851 },
> > +	{ 169, 11065, 65460395 },
> 
> If you possible, I want to know the 'unit' of the variable(factor_a, factor_b).

I am not sure there are really especially sensible units to give.

> 
> >  };
> >  
> >  static struct {
> > @@ -391,7 +392,8 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
> >  			   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
> >  
> >  		if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
> > -		    (val < 100 || val >= 0x3fb)) {
> > +		    (val < arizona_hpdet_b_ranges[range].threshold ||
> > +		     val >= 0x3fb)) {
> 
> I don't understand the meaning of 0x3fb hex value.
> I prefer to define constant variable for readability.

Thats fine I can add a define as part of this patch.

Thanks,
Charles
