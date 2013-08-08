Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab3HHR7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:59:15 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:41540 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3HHR7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:59:13 -0400
Date: Thu, 8 Aug 2013 10:59:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wei Ni <wni@nvidia.com>, "khali@linux-fr.org" <khali@linux-fr.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
Message-ID: <20130808175918.GA15013@roeck-us.net>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <1375944991-29182-2-git-send-email-wni@nvidia.com>
 <520359E9.1000600@roeck-us.net>
 <52036920.4050808@nvidia.com>
 <52037F9A.7070802@roeck-us.net>
 <5203D659.4050907@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5203D659.4050907@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 11:33:13AM -0600, Stephen Warren wrote:
> On 08/08/2013 05:23 AM, Guenter Roeck wrote:
> > On 08/08/2013 02:47 AM, Wei Ni wrote:
> ...
> >> I think get_regulator() will return error values, not only
> >> -EPROBE_DEFER, so we should set data->lm90_reg to NULL to handle other
> >> error values.
> >>
> > Matter of opinion if you want to check for IS_ERR or NULL later on.
> 
> No, if regulator returns either:
> 
> * Something valid
> * Someting IS_ERR()
> 
> ... then everywhere has to check the value using IS_ERR().
> 
> If regulator returns either:
> 
> * Something valid
> * Someting NULL
> 
> ... then everywhere has to check the value against NULL.
> 
Other drivers calling get_regulator() don't check against NULL,
so it should not be needed here either.

Guenter

> checking against both IS_ERR() and NULL shouldn't ever happen, and
> likewise IS_ERR_OR_NULL() is deprecated.
> 
