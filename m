Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab3JKN33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:29:29 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:38814 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3JKN31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:29:27 -0400
Message-ID: <5257FD34.2060406@gmail.com>
Date: Fri, 11 Oct 2013 07:29:24 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: autofs@vger.kernel.org, viro@ZenIV.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: NULL pointer dereference in autofs4_expire_wait
References: <525736C7.9080400@gmail.com>  <1381457199.2631.3.camel@perseus.fritz.box> <1381485327.2631.18.camel@perseus.fritz.box>
In-Reply-To: <1381485327.2631.18.camel@perseus.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/13 3:55 AM, Ian Kent wrote:
> On Fri, 2013-10-11 at 10:06 +0800, Ian Kent wrote:
>> On Thu, 2013-10-10 at 17:22 -0600, David Ahern wrote:
>>> Running 3.12-rc3 just hit BUG in autofs4_expire_wait
>>
>> It doesn't look like this could be due to Al's change to the locking in
>> autos4_wait() and that the only change to autofs that I'm aware of.
>>
>> Could you do a bisect please?
>
> Of course that assumes it's repeatable.
> Is it?
>
> Can you provide any information about the environment and activity that
> was happening at the time of the BUG()?

The system was up and running for 9 days before hitting the BUG. After 
that with 3 cpus on softlockup I had to do a reboot (forced). After the 
reboot I continued the workload again without a repeat incident (yet), 
so I am not sure bisect is going to be possible.

This is a corporate environment where practically everything is in an 
automount. Specific to this problem I was repeatedly building a 
workspace in one window, using cscope in another and checking code 
against a different workspace in a third -- all 3 of those were 
different automounts and different NAS servers.

 From objdump on vmlinux the line in question is fs/autofs4/expire.c:465

     if (ino->flags & AUTOFS_INF_EXPIRING) {

I will be continuing the sequence above today (working through compile 
problems for on OS port). I will bump the kernel to top of tree and see 
if it repeats.

David
