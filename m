Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaDPHDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:03:46 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:43041 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbaDPHDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:03:42 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <534E2B4B.30801@ladisch.de>
Date: Wed, 16 Apr 2014 09:03:39 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Emmanuel Colbus <ecolbus@manux.info>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][3/11][MANUX] Kernel compatibility : syscall numbers
References: <534D375B.9070806@manux.info>
In-Reply-To: <534D375B.9070806@manux.info>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emmanuel Colbus wrote:
> I have a question regarding vector 0x80.
>
> As I mentionned earlier, my OS's internals are very different from
> Linux's, thus I have had a need for a few new syscalls. Since I wanted
> to avoid any collision with Linux

... you could just use another vector, such as 0x81.

> but I also wanted to keep the ability to put the syscall table in
> a single 4096-byte page on 64-bit computers (on which I hope to run
> one day), I chose to start taking syscall number 511, and to progress
> downwards - currently, I'm using numbers 511 through 501 included

These implementation details do not need to show up in the interface:

int syscall_0x81(int nr, ...)
{
    if (nr in range)
        return table[511 - nr](...);
}


Regards,
Clemens
