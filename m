Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab3GRTmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:42:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43366 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759194Ab3GRTml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:42:41 -0400
Message-ID: <1374176560.1949.131.camel@joe-AO722>
Subject: Re: [PATCH v4] power: new trace event to print device suspend and
 resume time
From: Joe Perches <joe@perches.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, gregkh@linuxfoundation.org,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paul.gortmaker@windriver.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Thu, 18 Jul 2013 12:42:40 -0700
In-Reply-To: <1374175349-3435-1-git-send-email-shuah.kh@samsung.com>
References: <1374175349-3435-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 13:22 -0600, Shuah Khan wrote:
> A new trace event is added to pm events to print time it takes to suspend and
> resume a device. It generates trace message that includes device, driver,
> parent information in addition to the type of pm ops invoked as well as the
> pm event and error status from the pm ops. Example trace below:

Hi again Shuah.

Thanks, this looks good to me now.

Here's just one new trivial bit.

> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
[]
> @@ -56,6 +57,8 @@ static pm_message_t pm_transition;
[]
> +static char *pm_verb(int);

Instead of giving a prototype to a static, can
you move the static to this location instead?

It's a trivial function that just enumerates
the int and returns a descriptive char *

btw: it should be declared "const char *" too.

That could be a new patch if you're tired of
modifying this one.

cheers, Joe

