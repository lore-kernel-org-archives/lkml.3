Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaJKKWy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 06:22:54 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:51311 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaJKKWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 06:22:52 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Sat, 11 Oct 2014 12:20:04 +0200
From: Johan Hovold <johan@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Johan Hovold <johan@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/12] rtc: omap: silence bogus power-up reset message at
 probe
Message-ID: <20141011102004.GD18988@localhost>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-8-git-send-email-johan@kernel.org>
 <20141010180054.GS31348@saruman>
 <20141010180256.GU31348@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010180256.GU31348@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 01:02:56PM -0500, Felipe Balbi wrote:
> On Fri, Oct 10, 2014 at 01:00:54PM -0500, Felipe Balbi wrote:
> > On Thu, Oct 09, 2014 at 09:06:29PM +0200, Johan Hovold wrote:
> > > Some legacy RTC IP revisions has a power-up reset flag in the status
> > > register that later revisions lack.
> > > 
> > > As this flag is always read back as set on later revisions (or is
> > > overloaded with a different flag), make sure to only clear the flag and
> > > print the info message on legacy platforms.
> > > 
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > 
> > Reviewed-by: Felipe Balbi <balbi@ti.com>
> 
> oh, btw. This should be done for DT probes too.

What do you mean? This is for DT probes (of "ti,da830-rtc" and
"ti,am3352-rtc"). DT probing of legacy RTC IPs is currently not
supported.

Are you suggesting I should add a new compatible string for that?

Johan
