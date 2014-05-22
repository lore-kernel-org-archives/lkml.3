Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaEVN1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:27:42 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:61591 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaEVN1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:27:40 -0400
MIME-Version: 1.0
In-Reply-To: <672dd8e9-2857-49fb-848f-d38d38b23c9b@BN1BFFO11FD024.protection.gbl>
References: <672dd8e9-2857-49fb-848f-d38d38b23c9b@BN1BFFO11FD024.protection.gbl>
Date: Thu, 22 May 2014 08:27:39 -0500
Message-ID: <CAL_Jsq+1_W_d1WWkMUsHZYKXV=t9MN70iR25bnA8Emzh8zb2mg@mail.gmail.com>
Subject: Re: [RFC] Migrate to Hz resolution for OPP binding
From: Rob Herring <robherring2@gmail.com>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 5:30 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> Hi,
>
> I guess this is just to evaluate how big the lynch mob will be. Anyway:
> Triggered by this discussion https://lkml.org/lkml/2014/5/15/46, I
> looked a little into what it would take to migrate everybody to Hz
> frequency resolutions to avoid all the conversions between cpufreq, CCF,
> OPPs, etc.
> Turns out, OPPs are already stored in Hz resolution in the kernel, but the DT
> bindings use kHz resolution to specify them in DT. So, code-wise there
> is just a removal of a multiplication in the OPP parser (see below), but
> then there are the DT bindings...

Add this to the list of issues with the current OPP binding and define
a new binding, not a band-aid.

> As plan B, I was thinking to add the property 'operating-points-hz'...
>
> Any better ideas?

Fix clk_round_rate to specify how you want to round. There are
usecases for both rounding up and down. Don't you have the same
rounding problem with hz? Assume the person filling in OPP values
knows nothing about the kernel and you could have values rounded both
ways.

Rob
