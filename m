Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaLPVro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:47:44 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:60306 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaLPVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:47:43 -0500
Message-ID: <1418766460.9773.48.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: net: integer overflow in ip_idents_reserve
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dave Jones <davej@redhat.com>
Date: Tue, 16 Dec 2014 13:47:40 -0800
In-Reply-To: <5490A1F8.6020207@oracle.com>
References: <5490A1F8.6020207@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-16 at 16:19 -0500, Sasha Levin wrote:
> Hi Eric,
> 
> While fuzzing with trinity on a -next kernel with the undefined behaviour
> sanitizer path, I've observed the following warning in code which was
> introduced in 04ca6973f7 ("ip: make IP identifiers less predictable"):

This is a false positive.

We don't really care of the value if (now - old) is too big :

No packet was sent recently, so IP ID being X or Y is not a concern.



