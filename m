Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaAaUAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:00:33 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62607 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaAaUAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:00:31 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Pavel Machek <pavel@ucw.cz>, "David Rientjes" <rientjes@google.com>
From: Sebastian Capella <sebastian.capella@linaro.org>
In-Reply-To: <20140131122421.GA3305@amd.pavel.ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Michel Lespinasse" <walken@google.com>,
        "Shaohua Li" <shli@kernel.org>,
        "Jerome Marchand" <jmarchan@redhat.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>,
        "Joonsoo Kim" <iamjoonsoo.kim@lge.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
References: <1391039304-3172-1-git-send-email-sebastian.capella@linaro.org>
 <1391039304-3172-2-git-send-email-sebastian.capella@linaro.org>
 <20140131103232.GB1534@amd.pavel.ucw.cz>
 <alpine.DEB.2.02.1401310243090.7183@chino.kir.corp.google.com>
 <20140131122421.GA3305@amd.pavel.ucw.cz>
Message-ID: <20140131200029.13265.72190@capellas-linux>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v4 1/2] mm: add kstrimdup function
Date: Fri, 31 Jan 2014 12:00:29 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Machek (2014-01-31 04:24:21)
> Well, your /sys/power/resume patch would be nice cleanup, but it
> changs behaviour, too... which is unnice. Stripping trailing "\n" is
> probably neccessary, because we did it before. (It probably was a
> mistake). But kernel is not right place to second-guess what the user
> meant. Just return -EINVAL. This is kernel ABI, after all, not user
> facing shell.

Thanks guys!  I hadn't thought of these cases.

It sounds like we're really back to stripping one trailing \n to match
the sysfs behavior to which people have become accustomed, and leave
the rest of the string untouched in case the whitespace is intentional.

Should a user intentionally have input ending in a newline, then they
should add an additional newline, expecting it to be stripped, but
otherwise, their string is taken as entered.

Does this sound right?

Meanwhile, I'll try a test to see how name_to_dev_t handles files with
spaces in them.

Thanks,

Sebastian

