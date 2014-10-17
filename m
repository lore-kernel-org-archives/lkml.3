Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaJQNVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:21:52 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:55829 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaJQNVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:21:51 -0400
From: Nix <nix@esperi.org.uk>
To: Johan Hovold <johan@kernel.org>
Cc: Paul Martin <pm@debian.org>, Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
References: <878um4tg09.fsf@spindle.srvr.nix>
	<1409569752.24385.12.camel@linux-fkkt.site>
	<874mwnosz1.fsf@spindle.srvr.nix> <871tqe2zqt.fsf_-_@spindle.srvr.nix>
	<20141011195108.GA8275@thinkpad.nowster.org.uk>
	<87y4smz1l0.fsf@spindle.srvr.nix> <20141012185845.GB2786@localhost>
	<878uklynq9.fsf@spindle.srvr.nix> <20141014083432.GB7958@localhost>
Emacs: ... it's not just a way of life, it's a text editor!
Date: Fri, 17 Oct 2014 14:21:35 +0100
In-Reply-To: <20141014083432.GB7958@localhost> (Johan Hovold's message of
	"Tue, 14 Oct 2014 10:34:32 +0200")
Message-ID: <87k33yx25c.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-URT-Metrics: spindle 1060; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Oct 2014, Johan Hovold outgrape:
> Another thing you could try is to add back the 
>
> 	acm_set_control(acm, 0);
>
> just after the dev_info message in probe.

"Add back" suggests that this line existed before this change. It
didn't, as far as I can see. Probing has

acm_set_control(acm, acm->ctrlout);

*shutdown* has

acm_set_control(acm, acm->ctrlout = 0);

Did you mean that I should try adding back the acm_set_control() during
shutdown, or the one during probe?

-- 
NULL && (void)
