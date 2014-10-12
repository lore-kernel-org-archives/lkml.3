Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaJLSk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 14:40:29 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49471 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaJLSk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 14:40:26 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Sun, 12 Oct 2014 20:42:40 +0200
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
Message-ID: <20141012184240.GA2786@localhost>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-8-git-send-email-johan@kernel.org>
 <20141010180054.GS31348@saruman>
 <20141010180256.GU31348@saruman>
 <20141011102004.GD18988@localhost>
 <20141012005007.GC21128@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141012005007.GC21128@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 07:50:07PM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Sat, Oct 11, 2014 at 12:20:04PM +0200, Johan Hovold wrote:
> > On Fri, Oct 10, 2014 at 01:02:56PM -0500, Felipe Balbi wrote:
> > > On Fri, Oct 10, 2014 at 01:00:54PM -0500, Felipe Balbi wrote:
> > > > On Thu, Oct 09, 2014 at 09:06:29PM +0200, Johan Hovold wrote:
> > > > > Some legacy RTC IP revisions has a power-up reset flag in the status
> > > > > register that later revisions lack.
> > > > > 
> > > > > As this flag is always read back as set on later revisions (or is
> > > > > overloaded with a different flag), make sure to only clear the flag and
> > > > > print the info message on legacy platforms.
> > > > > 
> > > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > > 
> > > > Reviewed-by: Felipe Balbi <balbi@ti.com>
> > > 
> > > oh, btw. This should be done for DT probes too.
> > 
> > What do you mean? This is for DT probes (of "ti,da830-rtc" and
> > "ti,am3352-rtc"). DT probing of legacy RTC IPs is currently not
> > supported.
> > 
> > Are you suggesting I should add a new compatible string for that?
> 
> it seemed to me that you're only passing the new flag through
> platform_device_id table, not DT table. Did I miss something ?

Ah, that's just the way the driver currently encodes the IP revision
differences. The platform_device_id entries are references from
of_device_id data. Should probably clean that up as well.

Thanks again for the review. I'll post a new version when I'm back from
Düsseldorf and ELC-E/Plumbers.

Johan
