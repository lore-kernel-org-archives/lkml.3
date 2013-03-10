Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3CJPrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 11:47:09 -0400
Received: from mail2.sha-bang.de ([78.47.120.114]:45098 "EHLO mail.sha-bang.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3CJPrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 11:47:07 -0400
From: Sascha Wilde <wilde@sha-bang.de>
To: linux-kernel@vger.kernel.org
Cc: Salvatore Sisinni <s.sisinni@gmail.com>,
        Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: regression in linux 3.7 - fan speed at 100% after suspend/resume at 100%
In-Reply-To: <m2vc90798h.fsf@kenny.lan.sha-bang.de> (Sascha Wilde's message of
	"Sat, 09 Mar 2013 18:50:54 +0100")
References: <m2vc90798h.fsf@kenny.lan.sha-bang.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
Date: Sun, 10 Mar 2013 16:47:00 +0100
Message-ID: <m2d2v76yvf.fsf@kenny.lan.sha-bang.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha Wilde <wilde@sha-bang.de> wrote:
[...]
> [2]  FWIW², I'm under the stron impression that the whole fan control
>      changed in the latest vanilla kernels on my 6910p even before doing
>      a suspend/resume -- it seems to be more "binary" if you will, in
>      that the fan is not running at all for a while and then at a 100%
>      to return back to 0% after doing some serious cooling.  With 3.6.11
>      and older it is more "analogue", with slow fan when only a bit
>      cooling is needed.  No idea if this is related to the issue at
>      hand.

For that part of the problem I just discovered something that might be a
hint on the cause, there is no governor set for the thermal zones:

/sys/devices/virtual/thermal/thermal_zone0/policy : (null)
/sys/devices/virtual/thermal/thermal_zone1/policy : (null)
/sys/devices/virtual/thermal/thermal_zone2/policy : (null)
/sys/devices/virtual/thermal/thermal_zone3/policy : (null)
/sys/devices/virtual/thermal/thermal_zone4/policy : (null)

to my understanding this policies should default default to the
CONFIG_THERMAL_DEFAULT_GOV_*
configured in the kernel.  But it is always (null) for me.  And
something like 
# echo fair_share >/sys/devices/virtual/thermal/thermal_zone0/policy
does not work either.

Or is this expected behavior?

cheers
sascha
-- 
Sascha Wilde : "There are 10 types of people in the world. 
             : Those who understand binary and those who don't."
