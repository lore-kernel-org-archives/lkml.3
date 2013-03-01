Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3CAV46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:56:58 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:37140 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3CAV45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:56:57 -0500
MIME-Version: 1.0
In-Reply-To: <1362174860.3221.2.camel@thor.lan>
References: <20130228090846.GA249@x4>
	<20130301133159.0711f81a.akpm@linux-foundation.org>
	<20130301213511.GF2481@mtj.dyndns.org>
	<1362174860.3221.2.camel@thor.lan>
Date: Fri, 1 Mar 2013 13:56:54 -0800
X-Google-Sender-Auth: Oo7uV5m6OikXwC2x8418aKsLbIs
Message-ID: <CAOS58YOg20+i3beJsHJjedJ2sOrRfAakc=Pj84bZF0BatEU9HQ@mail.gmail.com>
Subject: Re: WARNING: at lib/idr.c:678 idr_find_slowpath+0x97/0xc0()
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, markus@trippelsdorf.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 1:54 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>> The WARN_ON() is just for cases where someone might be doing something
>> crazy with the previous behavior of ignoring high bit.  Maybe I was
>> being overly paranoid and we should just drop it from idr_find().
>
> Can we revert the __lock_timer patch as well then?

I don't know.  Andrew was worried about the type of timer id.  For
inotify, it's okay as the type is always int but it's not a bad idea
to have some form of sanitizing if the type might deviate.

Thanks.

-- 
tejun
