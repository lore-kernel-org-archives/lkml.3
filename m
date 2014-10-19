Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaJSNs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 09:48:59 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33771 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaJSNs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 09:48:58 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Sun, 19 Oct 2014 15:45:51 +0200
From: Johan Hovold <johan@kernel.org>
To: Nix <nix@esperi.org.uk>
Cc: Johan Hovold <johan@kernel.org>, Paul Martin <pm@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm)
 broken in 3.16
Message-ID: <20141019134551.GA2206@localhost>
References: <878um4tg09.fsf@spindle.srvr.nix>
 <1409569752.24385.12.camel@linux-fkkt.site>
 <874mwnosz1.fsf@spindle.srvr.nix>
 <871tqe2zqt.fsf_-_@spindle.srvr.nix>
 <20141011195108.GA8275@thinkpad.nowster.org.uk>
 <87y4smz1l0.fsf@spindle.srvr.nix>
 <20141012185845.GB2786@localhost>
 <878uklynq9.fsf@spindle.srvr.nix>
 <20141014083432.GB7958@localhost>
 <87k33yx25c.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k33yx25c.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 02:21:35PM +0100, Nix wrote:
> On 14 Oct 2014, Johan Hovold outgrape:
> > Another thing you could try is to add back the 
> >
> > 	acm_set_control(acm, 0);
> >
> > just after the dev_info message in probe.
> 
> "Add back" suggests that this line existed before this change. It
> didn't, as far as I can see. Probing has
> 
> acm_set_control(acm, acm->ctrlout);
> 
> *shutdown* has
> 
> acm_set_control(acm, acm->ctrlout = 0);
> 
> Did you mean that I should try adding back the acm_set_control() during
> shutdown, or the one during probe?

After the dev_info in probe as I wrote. acm->ctrlout will always be 0 at
that point, could have been more clear about that.

Johan
