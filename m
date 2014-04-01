Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaDAHCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:02:38 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:43537 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaDAHCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:02:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140331133918.GA2142@sucs.org>
References: <CAHnuAexDhxuzPrdA5OqOudL6-reAceM0CfAzKH=vQ+S2_++OYw@mail.gmail.com>
 <20140331133918.GA2142@sucs.org>
From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Date: Tue, 1 Apr 2014 09:01:55 +0200
Message-ID: <CAHnuAexhYVpBg3Hq9i79Yt7LmiAxaf=ZDFR14=EOQCd8HiwyuA@mail.gmail.com>
Subject: Re: Correct way to remove a cache device?
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Nicholas Swenson <nks@daterainc.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I couldn't figure out a predictable way to detach it properly. Even
when doing it as early as possible in the boot sequence, it'd succeed
anywhere from the first time I tried to seven reboots later.

I actually ended up doing something very nasty, but very efficient: I
simply dd zeroes to the beginning of the cache device, then reboot,
and the kernel would no longer recognize the cache device, and I could
continue normally.

Not pretty by any standard (actually makes me feel like showering),
but it works ;)
