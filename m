Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935242AbaKNQGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:06:48 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52580 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934727AbaKNQGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:06:46 -0500
X-Sasl-enc: Icw+VVGJ53ow8ZyWaVnJV6LojybScThXA/DftMBWsk5Z 1415981205
Message-ID: <1415981203.15154.45.camel@localhost>
Subject: Re: [PATCH v2 net-next 1/7] bpf: add 'flags' attribute to
 BPF_MAP_UPDATE_ELEM command
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 14 Nov 2014 17:06:43 +0100
In-Reply-To: <CAMEtUux2vuN3iNaAsxybyFwzfMRVe1+BOW-JvnvYYh+=-vpELw@mail.gmail.com>
References: <1415929010-9361-1-git-send-email-ast@plumgrid.com>
	 <1415929010-9361-2-git-send-email-ast@plumgrid.com>
	 <1415967071.15154.9.camel@localhost>
	 <CAMEtUux2vuN3iNaAsxybyFwzfMRVe1+BOW-JvnvYYh+=-vpELw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 2014-11-14 at 07:33 -0800, Alexei Starovoitov wrote:
> On Fri, Nov 14, 2014 at 4:11 AM, Hannes Frederic Sowa
> <hannes@stressinduktion.org> wrote:
> > On Do, 2014-11-13 at 17:36 -0800, Alexei Starovoitov wrote:
> >> the current meaning of BPF_MAP_UPDATE_ELEM syscall command is:
> >> either update existing map element or create a new one.
> >> Initially the plan was to add a new command to handle the case of
> >> 'create new element if it didn't exist', but 'flags' style looks
> >> cleaner and overall diff is much smaller (more code reused), so add 'flags'
> >> attribute to BPF_MAP_UPDATE_ELEM command with the following meaning:
> >>  #define BPF_ANY      0 /* create new element or update existing */
> >>  #define BPF_NOEXIST  1 /* create new element if it didn't exist */
> >>  #define BPF_EXIST    2 /* update existing element */
> >
> > Would a cmpxchg-alike function be handy here?
> 
> you mean cmpxchg command in addition to
> update() command ?
> May be... it will have an extra 'value' argument
> (key, old_value, new_value)
> I don't have a use case for it yet though.

I don't neither. ;)

I just wanted to bring this up before user space api might get public
and the additional argument might make problems.

Bye,
Hannes


