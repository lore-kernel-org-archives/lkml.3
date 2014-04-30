Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaD3CoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:44:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31755 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaD3CoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:44:19 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-0e-5360637dc7cb
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Catalin Marinas'" <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        "'Arnd Bergmann'" <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
References: <000201cf6367$c8084440$5818ccc0$@samsung.com>
 <20140429144052.GJ17007@arm.com>
In-reply-to: <20140429144052.GJ17007@arm.com>
Subject: Re: [PATCH v4 2/7] arm64: Decouple page size from level of translation
 tables
Date: Wed, 30 Apr 2014 11:44:13 +0900
Message-id: <007d01cf641e$122f9b20$368ed160$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQE5VUHIE8aJyTOAQ/hLT6p/NDXsYQMqZelpnDw8nOA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+Zvm5tckKwwenfuhZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZrFi3jI2iw8zVjI6
	8HismbeG0eP3r0mMHneu7WHzOL9pDbPH5iX1Hn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJXx
	c6NiwSruik9f/jE3ML7m6GLk5JAQMJFYNPM/K4QtJnHh3nq2LkYuDiGBZYwSbw/3M8IUde5d
	yQqRWMQo0TzrOTuE84dR4nDrMTaQKjYBTYlHd3vYQWwRAX2JxVdugHUwC3QwSyx9ugxslJBA
	jMTFBSvAGjgFdCXm7noHtltYIEJi7oLXzCA2i4CqxLxdb8BqeAUsJWbfPQBlC0r8mHyPBcRm
	FtCSWL/zOBOELS+xec1bZohTFSR2nH3NCBEXkdj34h2QzQF0kJXEoj3WIPdICCzkkLi+pp8N
	YpeAxLfJh1hAaiQEZCU2HYAaIylxcMUNlgmMErOQbJ6FZPMsJJtnIdm2gJFlFaNoakFyQXFS
	epGJXnFibnFpXrpecn7uJkZICpiwg/HeAetDjMlA6ycyS4km5wNTSF5JvKGxmZGFqYmpsZG5
	pRlpwkrivGqPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MPYLXt40vSHeY1OBwDeHtsDn
	7WUHuZL4e1ZFx+l/PXJa/2rUdXfDCa8tNjB5XlZ5fl3iXAnfLO7e7ATVjuCpa/w2LlxwUV9q
	v76Tj+K1d5rblrWlldrmqFxQ9DDfPsW6eWmE9H1HTqWP2lsPcuv+SDNQEjoqKbxP5/CptWt0
	vnUvl3/v88j9lRJLcUaioRZzUXEiAG8QQnsXAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAd3a5IRgg77PGhZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZrFi3jI2iw8zVjI6
	8HismbeG0eP3r0mMHneu7WHzOL9pDbPH5iX1Hn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0qZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsI4x4+dGxYJV3BWfvvxjbmB8zdHFyMkhIWAi0bl3JSuELSZx
	4d56ti5GLg4hgUWMEs2znrNDOH8YJQ63HmMDqWIT0JR4dLeHHcQWEdCXWHzlBitIEbNAB7PE
	0qfLGEESQgIxEhcXrABr4BTQlZi76x3YCmGBCIm5C14zg9gsAqoS83a9AavhFbCUmH33AJQt
	KPFj8j0WEJtZQEti/c7jTBC2vMTmNW+ZIU5VkNhx9jUjRFxEYt+Ld0A2B9BBVhKL9lhPYBSa
	hWTSLCSTZiGZNAtJ9wJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwQnmmfQOxlUNFocY
	BTgYlXh4BbbGBwuxJpYVV+YeYpTgYFYS4WUOSAgW4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR
	5Hxg8ssriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBkbdVN59
	wdc0N+9+v4LdqfFzkrkzm3xPwfpgpYi5nB6/5S16bWdfYT1catpWpbTv0ZKY9Mh55+115xaU
	LFn4THNZ0d7n37vmnjy+vtuwr/rS155ls2ep/GC/sf1xlMnVo9occXEBp/aEFJkYTxIOvpN3
	5cvEh1ZGMWt3W066uHLJTd8LvGw+S5KUWIozEg21mIuKEwGt6ThpdAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2014 11:41 PM, Catalin Marinas wrote:
> Jungseok,

Hi, Catalin

> On Tue, Apr 29, 2014 at 05:59:20AM +0100, Jungseok Lee wrote:
> > +choice
> > +	prompt "Level of translation tables"
> > +	default ARM64_3_LEVELS if ARM64_4K_PAGES
> > +	default ARM64_2_LEVELS if ARM64_64K_PAGES
> > +	help
> > +	  Allows level of translation tables.
> > +
> > +config ARM64_2_LEVELS
> > +	bool "2 level"
> > +	depends on ARM64_64K_PAGES
> > +	help
> > +	  This feature enables 2 levels of translation tables.
> > +
> > +config ARM64_3_LEVELS
> > +	bool "3 level"
> > +	depends on ARM64_4K_PAGES
> > +	help
> > +	  This feature enables 3 levels of translation tables.
> > +
> > +endchoice
> 
> As I mentioned previously
> (http://www.spinics.net/linux/lists/arm-kernel/msg319552.html), just expose options for the VA space
> bits rather than the number of levels.
> You can still keep the number of levels config options but not visible in menuconfig (though I think
> you could also hide them in some header and avoid config altogether). The VA bits config options can
> be:
> 
> VA_BITS_39 if 4K (3 levels)
> VA_BITS_42 if 64K (2 levels)
> VA_BITS_47 if 16K (3 levels)
> VA_BITS_48 if 4K || 16K || 64K (4/4/3 levels depending on page size)
> 
> That's more meaningful to people configuring the kernel.

Okay, I will revise VA_BITS config as hiding the number of levels.

Best Regards
Jungseok Lee

