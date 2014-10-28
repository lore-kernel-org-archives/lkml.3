Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaJ1VSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:18:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaJ1VSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:18:06 -0400
Date: Tue, 28 Oct 2014 14:18:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Guenter Roeck <linux@roeck-us.net>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtc: omap: add support for pmic_power_en
Message-Id: <20141028141805.7b67bba29734be326354957f@linux-foundation.org>
In-Reply-To: <20141028083633.GM2006@localhost>
References: <1413913086-12730-1-git-send-email-johan@kernel.org>
	<1414397368-26480-1-git-send-email-johan@kernel.org>
	<20141027154031.4492ea11d401045ca04a3ff8@linux-foundation.org>
	<20141028083633.GM2006@localhost>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 09:36:33 +0100 Johan Hovold <johan@kernel.org> wrote:

> > But it doesn't explain *why* we want the alarm to trigger before
> > returning.
> 
> Should we really require every power-off handler to document arch
> behaviour (even if its inconsistent and currently undocumented); in
> this case that some arches return to user-space where we may oops if
> called from process 0 (e.g. systemd, but not if using sysvinit)?

The kernel really doesn't have a problem related to excessive amounts
of useful code comments :(

The bottom line is: did I provide a reader with the ability to
understand why the code is this way?  If "no" then improvements beckon.

This does look like one code site where an elaborate explanation is
warranted.  There's no way in which a reader can get to your above
paragraph from the current rtc-omap.c.
