Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaL2MNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:13:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaL2MNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:13:22 -0500
Date: Mon, 29 Dec 2014 13:13:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Pavel Machek <pavel@ucw.cz>
cc: Andy Lutomirski <luto@amacapital.net>,
        kernel list <linux-kernel@vger.kernel.org>, yoongukim@cmu.edu,
        donghyu1@cmu.edu, omutlu@gmail.com
Subject: Re: DRAM unreliable under specific access patern
In-Reply-To: <20141224175040.GA28791@amd>
Message-ID: <alpine.LRH.2.00.1412291310000.12303@twin.jikos.cz>
References: <20141224163823.GA17035@amd> <CALCETrW8nrKSZ800C+WaHMK4DCuWnD9TG3dYo7cZwm5j4CpNJQ@mail.gmail.com> <20141224172506.GA23683@amd> <CALCETrVP2PtB82x4JFFsXDomNKgRTk_3LoMyyk5KCXN=f8_DJw@mail.gmail.com> <20141224175040.GA28791@amd>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2014, Pavel Machek wrote:

> Well... We could periodically scrub (every few miliseconds) pages
> mapped to userspace. 

I.e. implement ECC in software. Would be extremely slow though.

> We might be able to do some magic and disallow cache flushes to 
> userspace programs. 

My understanding is that cflush is not strictly necessary, it only makes 
the issue more likely to trigger.

If you modify the pattern so that it neraly fits into cacheline (but not 
really), you would be able to produce similar (if not the same) cache 
eviction pattern as if without explicit cflush. Right?

-- 
Jiri Kosina
SUSE Labs

