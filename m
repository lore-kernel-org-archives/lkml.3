Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbbAKWk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:40:58 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:41614 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbAKWkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:40:55 -0500
Date: Sun, 11 Jan 2015 14:40:39 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Richard Weinberger <richard@nod.at>
Cc: davem@davemloft.net, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bhutchings@solarflare.com,
        john.fastabend@gmail.com, herbert@gondor.apana.org.au,
        vyasevic@redhat.com, jiri@resnulli.us, vfalico@gmail.com,
        therbert@google.com, edumazet@google.com, yoshfuji@linux-ipv6.org,
        jmorris@namei.org, kuznet@ms2.inr.ac.ru, kadlec@blackhole.kfki.hu,
        kaber@trash.net, pablo@netfilter.org, kay@vrfy.org
Subject: Re: [PATCH 1/3] net: Make interface aliases available for general
 usage
Message-ID: <20150111144039.426f0c48@urahara>
In-Reply-To: <1421009571-5279-2-git-send-email-richard@nod.at>
References: <1421009571-5279-1-git-send-email-richard@nod.at>
	<1421009571-5279-2-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2015 21:52:49 +0100
Richard Weinberger <richard@nod.at> wrote:

> Allow interface aliases to be used as regular interfaces.
> Such that a command sequence like this one works:
> $ ip l set eth0 alias internet
> $ ip a s internet
> $ tcpdump -n -i internet
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

There is already a ifalias and it is used by SNMP.
But the common practice is to put longer descriptive names which aren't going
to be usable and there is no requirement that they be unique.

I think you can't do this without breaking some of our users.
