Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3GQM1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:27:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab3GQM1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:27:05 -0400
Date: Wed, 17 Jul 2013 14:29:45 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [BUG] 3.10 regression: hang on suspend
Message-ID: <20130717122944.GA25894@redhat.com>
References: <51E4501D.3010001@odi.ch>
 <20130716065626.GA1587@redhat.com>
 <51E4F790.6090308@odi.ch>
 <51E51712.4020609@broadcom.com>
 <51E58FA5.4000804@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51E58FA5.4000804@odi.ch>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 08:23:33PM +0200, Ortwin Glück wrote:
> Without NetworkManager, no X, on console and with plain jane wpa_supplicant I do
> echo mem > /sys/power state
> 
> After that, it still responds to keyboard events: I can switch VT
> and type on the consoles, but I can not login on a different VT
> (pressing Enter after the username doesn't return). So I guess tasks
> have been frozen, but it hangs in stopping devices.
> 
> settings for pm_test:
> devices: same behviour as above
> freezer: works as expected (stops tasks; sleeps; resumes tasks)
> 
> Nothing in the logs. How can I enable more log?

This looks like livelock, i.e. kernel wait for mutex to be released
but that never happen , for example because of deadlock. Enabling 
CONFIG_LOCKDEP=y could help to diagnose this. Other than that
sysreq key w (show blocked task) could help, see
Documentation/sysrq.txt for instructions how to use this key.
Also please remember set no_console_suspend boot option to
allow print messages on tty during suspend.

Stanislaw

