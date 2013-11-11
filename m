Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3KKPLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:11:14 -0500
Received: from plane.gmane.org ([80.91.229.3]:54880 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab3KKPLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:11:03 -0500
Date: Mon, 11 Nov 2013 14:59:12 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: Sam Ravnborg <public-sam-uyr5N9Q2VtJg9hUCZPvPmw@plane.gmane.org>
cc: Jonathan Nieder 
	<public-jrnieder-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        Guillem Jover 
	<public-guillem-+FW4gsLVM0RAfugRpC6u6w@plane.gmane.org>,
        public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        public-linux-kbuild-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        public-linux-api-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        Michal Marek <public-mmarek-AlSwsSmVLrQ@plane.gmane.org>,
        Justin Cormack <justin@specialbusservice.com>
Subject: Re: [PATCH] Use __unused0 instead of __unused for user visible struct
 member names
In-Reply-To: <20120103065659.GA32216@merkur.ravnborg.org>
Message-ID: <Pine.BSM.4.64L.1311111448490.23723@herc.mirbsd.org>
References: <20120102024418.GA10483@gaara.hadrons.org>
 <20120102202243.GA31103@elie.hsd1.il.comcast.net> <20120103065659.GA32216@merkur.ravnborg.org>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-TMDA-Confirmed: Mon, 11 Nov 2013 16:10:56 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Sam Ravnborg dixit:

>> Guillem Jover wrote:

>> > On BSD systems __unused has traditionally been defined to mean the
>> > equivalent of gcc's __attribute__((__unused__)), some parts of the
[…]
>^__ is reserved for libc internal stuff and there is no reason to
>name the unused/padding members "__unused".

Considering that glibc has seen the light¹ now too, can we please
do something about these now? The BSD tools (not just NetBSD®) have
been using this for far longer after all…


Currently (git pull --ff torvalds master), we have:

• 2 occurrences of files *inside* the Linux kernel defining __unused
  to² __attribute__((unused)) themselves

• 68 struct members and function arguments called __unused

>So one or a set of patches that rename them all to something more
>sensible would be fine.

I think __unused0 is okay as it matches current __unused[0-9] in
use by other parts of the Linux kernel – although glibc now uses
__glibc_reserved[0-9], I think this doesn’t look like the Linux
kernel should use it ☻☺


① http://thread.gmane.org/gmane.comp.lib.glibc.alpha/36439

② I’ve recently come to the belief that this should be
  __attribute__((__unused__)) in all cases, i.e. all those
  attribute namings need double underscores before and after,
  as some software likes to #define printf to something else,
  lighttpd does #define bounded something else, so there’s
  probably software out there containing #define unused foo.


