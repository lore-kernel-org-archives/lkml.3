Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965906AbaKNPdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:33:07 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61277 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965686AbaKNPdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:33:02 -0500
MIME-Version: 1.0
In-Reply-To: <1415967071.15154.9.camel@localhost>
References: <1415929010-9361-1-git-send-email-ast@plumgrid.com>
	<1415929010-9361-2-git-send-email-ast@plumgrid.com>
	<1415967071.15154.9.camel@localhost>
Date: Fri, 14 Nov 2014 07:33:00 -0800
Message-ID: <CAMEtUux2vuN3iNaAsxybyFwzfMRVe1+BOW-JvnvYYh+=-vpELw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/7] bpf: add 'flags' attribute to
 BPF_MAP_UPDATE_ELEM command
From: Alexei Starovoitov <ast@plumgrid.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 4:11 AM, Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
> On Do, 2014-11-13 at 17:36 -0800, Alexei Starovoitov wrote:
>> the current meaning of BPF_MAP_UPDATE_ELEM syscall command is:
>> either update existing map element or create a new one.
>> Initially the plan was to add a new command to handle the case of
>> 'create new element if it didn't exist', but 'flags' style looks
>> cleaner and overall diff is much smaller (more code reused), so add 'flags'
>> attribute to BPF_MAP_UPDATE_ELEM command with the following meaning:
>>  #define BPF_ANY      0 /* create new element or update existing */
>>  #define BPF_NOEXIST  1 /* create new element if it didn't exist */
>>  #define BPF_EXIST    2 /* update existing element */
>
> Would a cmpxchg-alike function be handy here?

you mean cmpxchg command in addition to
update() command ?
May be... it will have an extra 'value' argument
(key, old_value, new_value)
I don't have a use case for it yet though.
