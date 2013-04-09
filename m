Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936691Ab3DILpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:45:50 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:42194 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762364Ab3DILpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:45:49 -0400
Date: Tue, 9 Apr 2013 13:45:44 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Subject: Re: mfd: Core driver for Winbond chips
Message-ID: <20130409114544.GD7867@spo001.leaseweb.com>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net> <20130322205258.GE7867@spo001.leaseweb.com> <20130323002810.GA26245@roeck-us.net> <20130323174914.GA21563@roeck-us.net> <20130409093700.GM24058@zurbaran> <20130409113639.GA8731@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409113639.GA8731@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> I was waiting for feedback from Wim, who submitted a similar driver, about his
> thoughts. Key question is how to reserve access to the shared resource - either
> through an exported function in the mfd driver requesting a mutex, or through
> request_muxed_region(). I am going back and forth myself on which one is better.
> 
> Maybe it does not really matter, but using a function has the slight advantage
> that it auto-loads and locks the mfd module while one of its client modules
> is loaded. If we use request_muxed_region, that is not the case and the client
> module must use another means to request and lock the mfd module.
> 
> Maybe you have an opinion ?

This is indeed the main issue that has to be solved. Both options will work.
I like the auto-load and lock, but I need to look at the request_muxed_region
code again first before I can see what the possible drawbacks are :-).

Kind regards,
Wim.

