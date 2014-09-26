Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaIZAs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 20:48:59 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10849 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738AbaIZAs6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 20:48:58 -0400
Date: Thu, 25 Sep 2014 17:49:09 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Josh Cartwright <joshc@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2] pinctrl: qcom: use restart_notifier mechanism for
 ps_hold
Message-ID: <20140926004908.GC28481@sonymobile.com>
References: <1411505993-8414-1-git-send-email-joshc@codeaurora.org>
 <CACRpkdauNieUTSAR=PGsvrXOrPNsBgyCPC9Ot=ZDXctfSdEp8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CACRpkdauNieUTSAR=PGsvrXOrPNsBgyCPC9Ot=ZDXctfSdEp8w@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 25 Sep 00:41 PDT 2014, Linus Walleij wrote:

> On Tue, Sep 23, 2014 at 10:59 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> 
> > By converting to the restart_notifier mechanism for restart, we allow
> > for other mechanisms, like the watchdog, to be used for restart in the
> > case where PS_HOLD has failed to reset the chip.
> >
> > Since this mechanism may be one of several mechanisms registered, change
> > the post-ps_hold write timeout to be a more reasonable 1 second instead
> > of 10 seconds.
> >
> > Choose priority 128, as according to documentation, this mechanism "is
> > sufficient to restart the entire system".
> >
> > Cc: Pramod Gurav <pramod.gurav@smartplayin.com>
> > Cc: Guenter Roeck <linux@roeck-us.net>
> > Tested-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > ---
> >
> > Changes since v1:
> >   - Simplified conditional notifier block registration
> >   - Reduced wait time to 1s, which I've found to be sufficient on an IFC6410
> >     board.
> 
> Björn, are you OK with this patch?
> 

Indeed, this is better than overriding arm_pm_restart.

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Regards,
Bjorn
