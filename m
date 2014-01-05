Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905AbaAEFFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 00:05:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaAEFFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 00:05:47 -0500
Message-ID: <1388898334.5342.39.camel@marge.simpson.net>
Subject: Re: [PATCH] Revert "x86: Disable IST stacks for debug/int 3/stack
 fault for PREEMPT_RT"
From: Mike Galbraith <bitbucket@online.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Brian Silverman <bsilver16384@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Date: Sun, 05 Jan 2014 06:05:34 +0100
In-Reply-To: <1388897147.5342.36.camel@marge.simpson.net>
References: <20130917061329.4872.51468.reportbug@dell-inspiron-linux.dlinkrouter>
	 <1379427451.23881.48.camel@deadeye.wl.decadent.org.uk>
	 <CAP01z6LVxoA6kDJeL8NuO2aA22BjMvXSk9ZY7z9cOK1=k56vpg@mail.gmail.com>
	 <1379905562.3913.8.camel@deadeye.wl.decadent.org.uk>
	 <CAP01z6+j6moUio9pc3G3iz+ebJCdKEvngddxnxazRP+NXwLkyg@mail.gmail.com>
	 <1380115449.4430.21.camel@deadeye.wl.decadent.org.uk>
	 <52AE0419.3050103@linutronix.de> <20140103135548.GA6327@linutronix.de>
	 <20140104181807.GS20765@two.firstfloor.org>
	 <1388897147.5342.36.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:jszQB79Sh4Yd66uP+fYiBTmD9HNfTiPSof2VzXbqE32
 n+9Ekc0d1uziDU+nCMgrBUw4Tg3H2cJ3n3rH+sZbnGtiAr9Kw1
 xt+Y5QFkO+65ODoFT+lohSGTAhKlK00iVeqD29jz0ROiQNq/eh
 pqnkyJ5HM4ZQe1YeuVnwY+sW2nc2j1MVVjZoGfpctyPS/pN6Lb
 xMuNd55xYzjjLlZ/CsfxEycj8uMZ4cGUWbsnbkn6obXIf7Bus4
 SyrVVnzsms/lQChlPzQqsWNZHp5koDRk1WoSopi4/XDgKO602M
 X6YBhuwUJxaM5vaNY+FtE6uPRyrW8OBG6FnHRTrZgZkazh3SfO
 eYwJiUaSIpk2wkY+5cQcSmKkQjQ+utIHAkizXAifky5A4PHWme
 zyFqnyKvPhrCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-01-05 at 05:45 +0100, Mike Galbraith wrote:

> Or perhaps tell sleeping locks to spin in annoying spots?  I converted
> rt spinlocks globally to preemptible spinning locks (wasn't pretty, but
> worked), so seems that could work.

Bah.  Nope, if lock owner is on your cpu, you have to yield.

