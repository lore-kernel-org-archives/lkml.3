Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161997Ab3DEI5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 04:57:06 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6710 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130Ab3DEI5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 04:57:04 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
Date: Fri, 5 Apr 2013 10:57:00 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "Makarov, Aleksej" <Aleksej.Makarov@sonymobile.com>
Subject: Re: [PATCH] input: don't call input_dev_release_keys() in resume
Message-ID: <20130405085700.GH2481@caracas.corpusers.net>
References: <1362664882-16194-1-git-send-email-oskar.andero@sonymobile.com>
 <20130404163313.GA12302@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130404163313.GA12302@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:33 Thu 04 Apr     , Dmitry Torokhov wrote:
> Hi Oskar,
> 
> On Thu, Mar 07, 2013 at 03:01:22PM +0100, oskar.andero@sonymobile.com wrote:
> > From: Aleksej Makarov <aleksej.makarov@sonymobile.com>
> > 
> > When waking up the platform by pressing a specific key, sending a
> > release on that key makes it impossible to react on the event in
> > user-space.
> > 
> 
> No, we can not simply not release keys after resume from suspend, as
> this leads to keys being stuck. Consider you are holding an 'I' key on
> your external USB keyboard and close your laptop's lid. Then you release
> the key and leave. Later you come back, open the lid waking the laptop
> and observe endless stream of 'I' in your open terminal.

You're absolutely right. But I guess you also see the case that the
patch is trying to fix, right?

To explain our use-case: We have a physical camera button on some devices.
When the user long-presses the button, the system will wake up and jump
directly in to the camera application.

> Maybe we should release the keys during suspend time? I am not sure how
> Android infrastructure will react to this though...

That sounds like a good idea! Let me do some testing on that.

Thanks!

-Oskar
