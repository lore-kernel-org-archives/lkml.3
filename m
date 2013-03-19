Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab3CSUCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:02:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57403 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3CSUCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:02:11 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 19 Mar 2013 13:02:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] watchdog: w83627hf: Enable watchdog only once
Message-ID: <20130319200209.GA16827@roeck-us.net>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
 <1362957300-18223-3-git-send-email-linux@roeck-us.net>
 <51489FC2.40806@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51489FC2.40806@draigBrady.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 05:26:26PM +0000, Pádraig Brady wrote:
> On 03/10/2013 11:14 PM, Guenter Roeck wrote:
> > It is unnecessary to enable the logical device and WDT0 each time
> > the watchdog is accessed. Do it only once during initialization.
> 
> Is this also the case on systems where the superio
> chip is used for other things? I've the impression
> that this may break some systems (though I no longer
> have the hardware to test). Arbitration of multiple
> users of the superio device may be managed be a central
> user space app, or by a kernel level arbitrator.
> 
Not sure if I understand you correctly.

You mean some entity might actually disable the watchdog between accesses
to it by the watchdog driver ? That would make it pretty useless.
Might as well turn it off entirely if that is the case.

Or do you refer to _selecting_ the hwmon logical device ? If so, this patch
is about enabling it only once, not about selecting it only once.

Guenter
