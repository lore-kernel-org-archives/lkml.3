Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaEOD5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 23:57:08 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:58716 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaEOD5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 23:57:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140514150255.GA8330@amd.pavel.ucw.cz>
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
	<20140514150255.GA8330@amd.pavel.ucw.cz>
Date: Thu, 15 May 2014 09:27:05 +0530
Message-ID: <CAKohpo=MFxUHL22TxXPk4B=JX9AD3RGdgXPPGK9sD3GD6AEV+g@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "[Chander Kashyap" <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 May 2014 20:32, Pavel Machek <pavel@ucw.cz> wrote:
> Hmm. Would it be better to actually delete stale OPPs?

I wouldn't call them stale as dtb isn't going to change after boot
and we will always get the same list again, unless some arch has
added few more after boot.

So, there is no point freeing opp's once created. Just make sure
they aren't added again.
