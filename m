Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3KWGFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 01:05:49 -0500
Received: from science.horizon.com ([71.41.210.146]:23613 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752812Ab3KWGFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 01:05:30 -0500
Date: 23 Nov 2013 01:05:27 -0500
Message-ID: <20131123060527.15392.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dhowells@redhat.com, torvalds@linux-foundation.org
Subject: Re: [GIT] Security subsystem updates for 3.13
Cc: linux@horizon.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013, Linus Torvalds wrote:
> I do see *some* minimal comments on it from George Spelvin on lkml.

I'd like to apologize for dropping the ball on that.  I started working
on it seriously, but with various emergencies, I've been AFK from lkml
for the last month.

I'm not really thilled with it; I think the fanout of 16 is low for
something with its scale ambitions, and the properties expected of the
chunked key access method are not documented as clearly as they should be.

The way the key is fiddled the put keyring objects in a contiguous
range of the trie is a particularly egregious layering violation.

But I am convinced that it's been tested and works; my complaints are
in the areas of ugliness and efficiency.  And it's layered well enough that
it can be fixed later without radical sirgery.
