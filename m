Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaK3WIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 17:08:37 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42457 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaK3WIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 17:08:36 -0500
MIME-Version: 1.0
In-Reply-To: <87k32d13d5.fsf@mid.deneb.enyo.de>
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
 <87k32d13d5.fsf@mid.deneb.enyo.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 30 Nov 2014 14:08:13 -0800
Message-ID: <CALCETrV_aArOr7v4AqLHdyGGNU-5XBPmvBXEqbVU36EJ_G26uQ@mail.gmail.com>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Pavel Emelyanov <xemul@parallels.com>, criu@openvz.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 30, 2014 1:47 AM, "Florian Weimer" <fw@deneb.enyo.de> wrote:
>
> * Andy Lutomirski:
>
> > The initial implementation is straightforward: highpid is simply a
> > 64-bit counter. If a high-end system can fork every 3 ns (which
> > would be amazing, given that just allocating a pid requires at
> > atomic operation), it would take well over 1000 years for highpid to
> > wrap.
>
> I'm not sure if I'm reading the patch correctly, but is the counter
> namespaced?  If yes, why?

It's namespaced so that CRIU can migrate/restore a whole pid namespace.

--Andy
