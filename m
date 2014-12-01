Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaLAPVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:21:51 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47318 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753215AbaLAPVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:21:50 -0500
Date: Mon, 1 Dec 2014 17:21:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC v8 02/14] Documentation: leds: Add description of LED
 Flash class extension
Message-ID: <20141201152142.GT8907@valkosipuli.retiisi.org.uk>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-3-git-send-email-j.anaszewski@samsung.com>
 <20141129125832.GA315@amd>
 <547C539A.4010500@samsung.com>
 <20141201130437.GB24737@amd>
 <547C7420.4080801@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547C7420.4080801@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek and Pavel,

On Mon, Dec 01, 2014 at 02:58:56PM +0100, Jacek Anaszewski wrote:
> Hi Pavel,
> 
> On 12/01/2014 02:04 PM, Pavel Machek wrote:
> >Hi!
> >
> >>>How are faults cleared? Should it be list of strings, instead of
> >>>bitmask? We may want to add new fault modes in future...
> >>
> >>Faults are cleared by reading the attribute. I will add this note.
> >>There can be more than one fault at a time. I think that the bitmask
> >>is a flexible solution. I don't see any troubles related to adding
> >>new fault modes in the future, do you?
> >
> >I do not think that "read attribute to clear" is good idea. Normally,
> >you'd want the error attribute world-readable, but you don't want
> >non-root users to clear the errors.
> 
> This is also V4L2_CID_FLASH_FAULT control semantics.
> Moreover many devices clear the errors upon reading register.
> I don't see anything wrong in the fact that an user can clear
> an error. If the user has a permission to use a device then
> it also should be allowed to clear the errors.

I agree. Some of these such as the timeout are not hardware related
problems at all, but others may be. I'd keep the same semantics as V4L2
already does.

> >I am not sure if bitmask is good solution. I'd return space-separated
> >strings like "overtemp". That way, there's good chance that other LED
> >drivers would be able to use similar interface...
> 
> The format of a sysfs attribute should be concise.
> The error codes are generic and map directly to the V4L2 Flash
> error codes.

I'd guess a single application accesses either of the interfaces. From that
point of view it doesn't matter what are the bit definitions in V4L2.

The behaviour on sysfs could also be different, e.g. writing the attribute
would clear the faults. This would need more functionality from drivers.
The V4L2 behaviour mirrors the typical behaviour of flash controllers ---
the chips mostly do not operate until the faults have been read, and the
interface as well as the interface take no stance to that. So when the user
reads the fault control value, the fault register on the chip is cleared as
well.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
