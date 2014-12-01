Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaLAGrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 01:47:41 -0500
Received: from albireo.enyo.de ([46.237.207.196]:46332 "EHLO albireo.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbaLAGrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 01:47:39 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Pavel Emelyanov <xemul@parallels.com>, criu@openvz.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
	<87k32d13d5.fsf@mid.deneb.enyo.de>
	<CALCETrV_aArOr7v4AqLHdyGGNU-5XBPmvBXEqbVU36EJ_G26uQ@mail.gmail.com>
Date: Mon, 01 Dec 2014 07:47:26 +0100
In-Reply-To: <CALCETrV_aArOr7v4AqLHdyGGNU-5XBPmvBXEqbVU36EJ_G26uQ@mail.gmail.com>
	(Andy Lutomirski's message of "Sun, 30 Nov 2014 14:08:13 -0800")
Message-ID: <87egsjrhmp.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andy Lutomirski:

> On Nov 30, 2014 1:47 AM, "Florian Weimer" <fw@deneb.enyo.de> wrote:
>>
>> * Andy Lutomirski:
>>
>> > The initial implementation is straightforward: highpid is simply a
>> > 64-bit counter. If a high-end system can fork every 3 ns (which
>> > would be amazing, given that just allocating a pid requires at
>> > atomic operation), it would take well over 1000 years for highpid to
>> > wrap.
>>
>> I'm not sure if I'm reading the patch correctly, but is the counter
>> namespaced?  If yes, why?
>
> It's namespaced so that CRIU can migrate/restore a whole pid namespace.

Oh well, this requirement is at odds with system-wide uniqueness.  Is
CRIU really that important? :-)
