Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161901AbaKNUvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:51:52 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:34593 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbaKNUvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:51:50 -0500
MIME-Version: 1.0
In-Reply-To: <1415998051.1847.2.camel@sipsolutions.net>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
 <1415693712-23743-11-git-send-email-mcgrof@do-not-panic.com> <1415998051.1847.2.camel@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 14 Nov 2014 12:51:27 -0800
X-Google-Sender-Auth: AZJseiXBU3I1063Gp-k7fSqqh4g
Message-ID: <CAB=NE6XLKFfHqga_1kc0fYGxj5Y2o32NSqD3=idyT7+pXUsSpA@mail.gmail.com>
Subject: Re: [PATCH v3 10/21] backports: avoid git tree reinitialization
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>, Stefan Assmann <sassmann@kpanic.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 12:47 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2014-11-11 at 00:15 -0800, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>
>> When using backports against for packaging with --gitdebug you either
>> have to use --clean or assume the directory is empty already. In either
>> case you start fresh. With integration this will be a bit different, you
>> could end up with a project directory where the git tree was present but
>> only the target directory was empty.
>>
>> Calling git init on an already existing git directory will reinitialize
>> your git tree, that can reset some config stuff, let's avoid that.
>
> I guess I don't care much, but it seems strange to me that you'd use
> --gitdebug in this case, you'd end up committing crappy patches to the
> top-level kernel tree?

It was very useful to me when debugging, hence --gitdebug. Also, each
step is actually what some folks may want to see done / committed as
that may have been work done manually before for each kernel release
bump, now its just automated.

 Luis
