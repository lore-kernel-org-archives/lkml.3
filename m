Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaBKSTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:19:25 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:51271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaBKSTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:19:22 -0500
Message-ID: <1392142750.4128.37.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH v3] ieee80211: Print human-readable disassoc/deauth
 reason codes
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: Calvin Owens <jcalvinowens@gmail.com>, Joe Perches <joe@perches.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Feb 2014 19:19:10 +0100
In-Reply-To: <52FA546B.1060008@meshcoding.com>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
	 <1391661863.30094.56.camel@joe-AO722>
	 <1392030546.4128.11.camel@jlt4.sipsolutions.net>
	 <1392050359.2507.10.camel@joe-AO722> <20140211012523.GA2739@gmail.com>
	 <1392082740.2507.49.camel@joe-AO722> <20140211163738.GA32043@gmail.com>
	 <52FA546B.1060008@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 17:48 +0100, Antonio Quartulli wrote:
> On 11/02/14 17:37, Calvin Owens wrote:
> > Create a function to return a descriptive string for each reason code,
> > and print that in addition to the numeric value in the kernel log. These
> > codes are easily found on popular search engines, but one is generally
> > not able to access the internet when dealing with wireless connectivity
> > issues.
> > 
> > Changes in v2: Refactored array of strings into switch statement.
> > Changes in v3: Fix style problem, use simplifying macro for switch
> > statement, eliminate temporary enum variable.
> > 
> > Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
> > ---
> >  include/net/mac80211.h | 10 +++++++++
> >  net/mac80211/main.c    | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  net/mac80211/mlme.c    | 12 +++++------
> >  3 files changed, 73 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> > index f4ab2fb..d18acfe 100644
> > --- a/include/net/mac80211.h
> > +++ b/include/net/mac80211.h
> > @@ -2971,6 +2971,16 @@ struct ieee80211_ops {
> >   */
> >  struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
> >  					const struct ieee80211_ops *ops);
> > +/**
> > + * ieee80211_get_reason_code_string - Get human readable reason code
> > + *
> > + * This function returns a string describing the @reason_code.
> > + *
> > + * @reason_code: Reason code
> 
> Kerneldoc is not properly formatted here.
> The "@argument:" clause should be on the line right after the function
> name (as explained in Documentation/kernel-doc-nano-HOWTO.txt), e.g.:

I'm pretty sure it gets parsed correctly anyway, see e.g.
https://www.kernel.org/doc/htmldocs/80211/API-ieee80211-alloc-hw.html
(which is the function right above with the same style)

johannes

