Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbaAJTwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:52:46 -0500
Received: from forward1m.mail.yandex.net ([37.140.138.1]:55394 "EHLO
	forward1m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbaAJTwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:52:44 -0500
From: Victor Porton <porton@narod.ru>
Envelope-From: porton@yandex.ru
To: Joshua Brindle <brindle@quarksecurity.com>
Cc: "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <52D04C59.20406@quarksecurity.com>
References: <1171389381947@web15m.yandex.ru> <52D04C59.20406@quarksecurity.com>
Subject: Re: Create new NetFilter table
MIME-Version: 1.0
Message-Id: <25561389383560@web15m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 10 Jan 2014 21:52:40 +0200
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



10.01.2014, 21:39, "Joshua Brindle" <brindle@quarksecurity.com>:
> Victor Porton wrote:
>
>> šI propose to create a new NetFilter table dedicated to rules created programmatically (not by explicit admin's iptables command).
>>
>> šOtherwise an admin could be tempted to say `iptables -F security` which would probably break rules created for example by sandboxing software (which may follow same-origin policy to restrict one particular program to certain domain and port only). Note that in this case `iptables -F security` is a security risk (sandbox breaking)?
>>
>> šNew table could be possibly be called:
>>
>> š- temp
>> š- temporary
>> š- auto
>> š- automatic
>> š- volatile
>> š- daemon
>> š- system
>> š- sys
>>
>> šIn iptables docs it should be said that this table should not be manipulated manually.
>
> Is it possible that the solution to your sandboxing problem is seccomp
> filter?
>
> http://outflux.net/teach-seccomp/
>
> You'd filter out any syscall that can make outbound connections and then
> only pass already opened sockets to the sandboxed threads?
>
> seccomp filter was actually created for sandboxing, so that user
> applications could voluntarily shed the ability to call certain syscalls
> before handling untrusted data.

seccomp would not work for me, because I need network enabled sandboxes. Moreover we should be able to filter out certain subnets such as 127.0.0.0/255.0.0.0 (and others), This cleanly can't be done with seccomp.

-- 
Victor Porton - http://portonvictor.org
