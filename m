Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935220AbaKNMLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:11:16 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43508 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933262AbaKNMLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:11:14 -0500
X-Sasl-enc: 1jIuLqJsKY+8IENRjvvI5XX1Hl/mp6om70GKhbHvOqwt 1415967073
Message-ID: <1415967071.15154.9.camel@localhost>
Subject: Re: [PATCH v2 net-next 1/7] bpf: add 'flags' attribute to
 BPF_MAP_UPDATE_ELEM command
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <edumazet@google.com>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Nov 2014 13:11:11 +0100
In-Reply-To: <1415929010-9361-2-git-send-email-ast@plumgrid.com>
References: <1415929010-9361-1-git-send-email-ast@plumgrid.com>
	 <1415929010-9361-2-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 2014-11-13 at 17:36 -0800, Alexei Starovoitov wrote:
> the current meaning of BPF_MAP_UPDATE_ELEM syscall command is:
> either update existing map element or create a new one.
> Initially the plan was to add a new command to handle the case of
> 'create new element if it didn't exist', but 'flags' style looks
> cleaner and overall diff is much smaller (more code reused), so add 'flags'
> attribute to BPF_MAP_UPDATE_ELEM command with the following meaning:
>  #define BPF_ANY	0 /* create new element or update existing */
>  #define BPF_NOEXIST	1 /* create new element if it didn't exist */
>  #define BPF_EXIST	2 /* update existing element */

Would a cmpxchg-alike function be handy here?

Bye,
Hannes


