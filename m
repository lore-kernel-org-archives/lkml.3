Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaETLYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:24:24 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35256 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaETLYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:24:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpoknoFuz8qnDpunA7oxr5E_18=+EQsFEy0P39fcU=4Ps9w@mail.gmail.com>
References: <1400230809-11401-1-git-send-email-chander.kashyap@linaro.org>
	<537A0247.1030503@ti.com>
	<CAKohpoknoFuz8qnDpunA7oxr5E_18=+EQsFEy0P39fcU=4Ps9w@mail.gmail.com>
Date: Tue, 20 May 2014 06:24:20 -0500
X-Google-Sender-Auth: gl0OUTq3_Dtztzwhh9qouLAYRWM
Message-ID: <CAGo_u6o+Vysq0LkdFTrP82WOpS1TT-=MD+zgP+Q_L=3RV8x5hA@mail.gmail.com>
Subject: Re: [PATCH v3] PM / OPP: discard duplicate OPPs
From: Nishanth Menon <nm@ti.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Chander Kashyap <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:00 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> I have asked this on the earlier thread as well, let me ask it again.
> What would callers do on return value of EEXIST ? Is there anything
> special we may want to handle ?

That is upto the caller. returning 0 for an operation we were supposed
to do, but due to error checks, did not do, implies we need to provide
appropriate error back to caller. caller may choose to act upon the
error and do something OR not - depending on what the caller is (for
example, caller may choose to abort the full sequence as it does not
trust the entries anymore, OR maybe trying to add optional OPP - whose
failure is ignored) - it is NOT upto the this code to implement that
policy.

Regards,
Nishanth Menon
