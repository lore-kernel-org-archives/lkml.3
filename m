Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab3FSHQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:16:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48538 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab3FSHQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:16:22 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-b8-51c15ac44ea6
Date: Wed, 19 Jun 2013 09:16:12 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH v3 1/3] cpufreq: Add boost frequency support in core
Message-id: <20130619091612.60e4d69d@amdc308.digital.local>
In-reply-to: <20130618154456.56d99e18@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <20130617155156.4c729b5a@amdc308.digital.local>
 <CAKohpo=_=u35wTb-ZUXrR2hNno+ryAqq4gSC3EiJr=-bmgb9JQ@mail.gmail.com>
 <3258927.Qds4G9CTyG@vostro.rjw.lan>
 <20130618154456.56d99e18@amdc308.digital.local>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xoO6RqIOBBl1ntCwaroZY/Hm7nNXi
	adMPdot5n2UtOs8+YbboXXCVzeLNI26LNw83M1pc3jWHzeJz7xFGi9uNK9gs+hf2Mll0HPnG
	bLHxq4cDn8eda3vYPNZNe8vs0bdlFaPHo8UtjB6fN8kFsEZx2aSk5mSWpRbp2yVwZczY1cRY
	MIWr4v7js6wNjD0cXYycHBICJhJL3i1lhLDFJC7cW8/WxcjFISQwnVGi6fdrNpCEkEA7k8SJ
	V6VdjBwcLAKqEpen2YGE2QT0JD7ffcoEYosI+EqsfXyZEaSXWWABi0TP0ZOsIAlhAQ+Jc0em
	gS3gFbCW2Pn8LJjNKWAj8f7fGahl05gkFk25CraMX0BSov3fD2aIi+wkzn3awA7RLCjxY/I9
	FhCbWUBLYvO2JlYIW15i85q3zBMYBWchKZuFpGwWkrIFjMyrGEVTC5ILipPSc430ihNzi0vz
	0vWS83M3MYKj55n0DsZVDRaHGAU4GJV4eBtXHggUYk0sK67MPcQowcGsJMKr53AwUIg3JbGy
	KrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVAMj0yyOfAPP111LToQ1
	J3g+yv3BdEzmmSyDwJewTPfpvezPf1o5fFXg3Pfi7Bxe09O3zM0LPJcqVhnxxe2ZlRZhfvGD
	5EbxA9/Ovt2pm8PWurX5o8bFv4mTP02Y3X5Z8ivbRbMfxiJOZa8X3nKSlk0W051o87ZY44fQ
	8hWVh8TLGyftOa98QmOGEktxRqKhFnNRcSIAgxgCLpoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013 15:44:56 +0200, Lukasz Majewski wrote:

Dear Viesh, Rafael,

> > 
> > I'd recommend you both to read Documentation/cpu-freq/boost.txt
> > now. :-)  
> 
> 
> According to the documentation:
> "Reading the file is always supported, even if the processor does not
> support boosting. In this case the file will be read-only and always
> reads as "0""
> 
> Hmm, in the proposed patch set, the "boost" attribute is only exported
> when cpufreq driver sets boost_supported flag. 

I would like to clarify the above issue. 

When I've discussed with Viresh previous version of this patch, we have
agreed, that "boost" sysfs attribute [*]:
/sys/devices/system/cpu/cpufreq/boost

would be only visible when boost_supported flag is set at cpufreq
driver. 

When acpi-cpufreq driver doesn't support boost, the attribute [*]
won't be exported at all. This contradicts the documentation and legacy
acpi-cpufreq behaviour. 

Since I'm affraid to break API (with all its consequences :-) ), I would
like to be sure that this is OK, and thereof I'm allowed to rewrite
documentation accordingly.

I simply need explicit permission from both maintainers :-).

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
