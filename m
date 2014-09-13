Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaIMJNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 05:13:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbaIMJNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 05:13:06 -0400
Message-ID: <54140A87.603@redhat.com>
Date: Sat, 13 Sep 2014 11:12:39 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: davem@davemloft.net, ast@plumgrid.com, keescook@chromium.org,
        hannes@stressinduktion.org, spender@grsecurity.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bpf: correctly handle errors in sk_attach_filter()
References: <1410581190-31922-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1410581190-31922-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2014 06:06 AM, Sasha Levin wrote:
> Commit "net: bpf: make eBPF interpreter images read-only" has changed bpf_prog
> to be vmalloc()ed but never handled some of the errors paths of the old code.
>
> On error within sk_attach_filter (which userspace can easily trigger), we'd
> kfree() the vmalloc()ed memory, and leak the internal bpf_work_struct.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

[ This patch is for net-next. ]

Acked-by: Daniel Borkmann <dborkman@redhat.com>
