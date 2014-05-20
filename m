Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaETPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:25:56 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:61852 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbaETPZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:25:55 -0400
Date: Tue, 20 May 2014 08:25:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dudley Du <dudl@cypress.com>, Benson Leung <bleung@google.com>,
        Daniel Kurtz <djkurtz@google.com>, David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] input: cyapa: enable/disable trackpad device based
 on LID state
Message-ID: <20140520152551.GB9444@core.coreip.homeip.net>
References: <77BC725C9062764F874D79F51E1F1A8F40C14099@S04-MBX01-01.s04.local>
 <20140520034302.GB986@core.coreip.homeip.net>
 <1507406.BNOsJcxmP9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507406.BNOsJcxmP9@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 02:40:12PM +0200, Rafael J. Wysocki wrote:
> On Monday, May 19, 2014 08:43:02 PM Dmitry Torokhov wrote:
> > Hi Dudley,
> > 
> > On Wed, Apr 16, 2014 at 08:39:34AM +0000, Dudley Du wrote:
> > > Rely on EV_SW and SW_LID bits to identify a LID device, and hook
> > > up our filter to listen for SW_LID events to enable/disable touchpad when
> > > LID is open/closed.
> > > TEST=test on Chomebooks.
> > 
> > This is a policy and it does not belong in the kernel. Please work with
> > Rafael to establish generic interface to put devices into low power mode
> > (like accelerating runtime PM idle timeout)
> 
> I'm not really sure what you mean here, care to be more specific?

I think we chatted about this before - we need a uniform interface for
userspace to put devices into low power mode on demand. As
implementation detail I thought we could require runtime PM for that and
simply pretend that the PM timeout expired early when userspace invokes
that API.

> 
> > and use it when userspace detects that lid is closed.
> 
> I guess we get an event then, don't we?

Right, userspace gets EV_SW/SW_LID input event and needs to react. In
this particular case the desire is to power down touchpad (since it is
unaccessible). I am not sure why system suspend (which I expect happen
in reaction to lid closing) is not enough, but that's question for
Dudley.

Thanks.

-- 
Dmitry
