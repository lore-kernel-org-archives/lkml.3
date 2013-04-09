Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936952Ab3DIHgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:36:50 -0400
Received: from mx2.parallels.com ([199.115.105.18]:47416 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3DIHgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:36:48 -0400
Message-ID: <5163C53C.3050106@parallels.com>
Date: Tue, 9 Apr 2013 11:37:32 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Lennart Poettering <lpoetter@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, <linux-kernel@vger.kernel.org>,
        <jpoimboe@redhat.com>, <dhaval.giani@gmail.com>,
        <workman-devel@redhat.com>
Subject: Re: cgroup: status-quo and userland efforts
References: <20130406012159.GA17159@mtj.dyndns.org> <5162CA21.4060108@parallels.com> <51635371.7070104@redhat.com>
In-Reply-To: <51635371.7070104@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 03:32 AM, Lennart Poettering wrote:
> The other big thing we want from the systemd side is saner notifications
> when cgroups run empty. i.e. currently we don't get these at all in
> containers (since the agent can be only installed once, for the host).
> And the way we get this is awful, via kernel-spawned processes. I am
> looking for a way how I can establish a watch on a certain subtree (not
> just one directory) and get simple notifications in a race-free whenever
> a cgroup runs empty.
> 

Well, as I am trying to port our tools for Upstream Linux (aka cgroups),
I also got a pet peeve on this one as well. The notification system is
global and done at the root level. IOW, notify_on_release is local, but
release_agent is global.

We use our management tool to enter containers and call something like
init 0, that will shut the container down. But if the admin does it
itself, the cgroup directory will stay there. We would like them to
automatically disappear.

Maybe that is not something that needs to be done in the kernel. If
systemd had some very easy and well documented way for a 3rd party
software to register a notification to be called upon a certain cgroup
release (if it exists already, sorry Lennart, but I haven't found
anything in the likes. Just enlighten me)


