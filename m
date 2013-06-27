Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3F0P3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:29:43 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:46168 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3F0P3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:29:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130627132206.GE4003@sergelap>
References: <20130406012159.GA17159@mtj.dyndns.org> <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
 <20130422214159.GG12543@htj.dyndns.org> <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org> <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org> <1372311907.5871.78.camel@marge.simpson.net>
 <20130627132206.GE4003@sergelap>
From: Tim Hockin <thockin@hockin.org>
Date: Thu, 27 Jun 2013 08:29:21 -0700
X-Google-Sender-Auth: B8LkUXbCn2Iq82OVJJDSGQskgvg
Message-ID: <CAAAKZwt9QdddFrEjvdBsi3sbQXScKyzY=vZpYXqTwjGUebH1Ag@mail.gmail.com>
Subject: Re: cgroup: status-quo and userland efforts
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Mike Galbraith <bitbucket@online.de>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        jpoimboe <jpoimboe@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 6:22 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> Quoting Mike Galbraith (bitbucket@online.de):
>> On Wed, 2013-06-26 at 14:20 -0700, Tejun Heo wrote:
>> > Hello, Tim.
>> >
>> > On Mon, Jun 24, 2013 at 09:07:47PM -0700, Tim Hockin wrote:
>> > > I really want to understand why this is SO IMPORTANT that you have to
>> > > break userspace compatibility?  I mean, isn't Linux supposed to be the
>> > > OS with the stable kernel interface?  I've seen Linus rant time and
>> > > time again about this - why is it OK now?
>> >
>> > What the hell are you talking about?  Nobody is breaking userland
>> > interface.  A new version of interface is being phased in and the old
>> > one will stay there for the foreseeable future.  It will be phased out
>> > eventually but that's gonna take a long time and it will have to be
>> > something hardly noticeable.  Of course new features will only be
>> > available with the new interface and there will be efforts to nudge
>> > people away from the old one but the existing interface will keep
>> > working it does.
>>
>> I can understand some alarm.  When I saw the below I started frothing at
>> the face and howling at the moon, and I don't even use the things much.
>>
>> http://lists.freedesktop.org/archives/systemd-devel/2013-June/011521.html
>>
>> Hierarchy layout aside, that "private property" bit says that the folks
>> who currently own and use the cgroups interface will lose direct access
>> to it.  I can imagine folks who have become dependent upon an on the fly
>> management agents of their own design becoming a tad alarmed.
>
> FWIW, the code is too embarassing yet to see daylight, but I'm playing
> with a very lowlevel cgroup manager which supports nesting itself.
> Access in this POC is low-level ("set freezer.state to THAWED for cgroup
> /c1/c2", "Create /c3"), but the key feature is that it can run in two
> modes - native mode in which it uses cgroupfs, and child mode where it
> talks to a parent manager to make the changes.

In this world, are users able to read cgroup files, or do they have to
go through a central agent, too?

> So then the idea would be that userspace (like libvirt and lxc) would
> talk over /dev/cgroup to its manager.  Userspace inside a container
> (which can't actually mount cgroups itself) would talk to its own
> manager which is talking over a passed-in socket to the host manager,
> which in turn runs natively (uses cgroupfs, and nests "create /c1" under
> the requestor's cgroup).

How do you handle updates of this agent?  Suppose I have hundreds of
running containers, and I want to release a new version of the cgroupd
?

(note: inquiries about the implementation do not denote acceptance of
the model :)

> At some point (probably soon) we might want to talk about a standard API
> for these things.  However I think it will have to come in the form of
> a standard library, which knows to either send requests over dbus to
> systemd, or over /dev/cgroup sock to the manager.
>
> -serge
