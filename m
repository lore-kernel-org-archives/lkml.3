Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaIMJZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 05:25:06 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57565 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbaIMJZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 05:25:01 -0400
X-Sasl-enc: fA8ahokfyMa03sHglcnw+pEH+8uvX4Z1/zL/gZbs5ORG 1410600295
Message-ID: <1410600293.25850.2.camel@localhost>
Subject: Re: [PATCH] net: bpf: correctly handle errors in sk_attach_filter()
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: davem@davemloft.net, ast@plumgrid.com, keescook@chromium.org,
        dborkman@redhat.com, spender@grsecurity.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 13 Sep 2014 11:24:53 +0200
In-Reply-To: <1410581190-31922-1-git-send-email-sasha.levin@oracle.com>
References: <1410581190-31922-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sa, 2014-09-13 at 00:06 -0400, Sasha Levin wrote:
> Commit "net: bpf: make eBPF interpreter images read-only" has changed bpf_prog
> to be vmalloc()ed but never handled some of the errors paths of the old code.
> 
> On error within sk_attach_filter (which userspace can easily trigger), we'd
> kfree() the vmalloc()ed memory, and leak the internal bpf_work_struct.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Yeah, thanks, we missed that somehow.

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Bye,
Hannes


