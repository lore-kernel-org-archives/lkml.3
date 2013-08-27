Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3H0KX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:23:29 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38350 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3H0KX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:23:28 -0400
X-AuditID: 85900ec0-d1328b9000001514-be-521c7e1df742
Message-ID: <521C7E1C.5060502@hitachi.com>
Date: Tue, 27 Aug 2013 19:23:24 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [RFC PATCH 08/11] trace-cmd: Apply the trace-msg protocol
 for communication between a server and clients
References: <20130819094620.26597.79499.stgit@yunodevel> <20130819094639.26597.44449.stgit@yunodevel> <20130820135658.5a5d6e28@gandalf.local.home> <521AB469.40201@hitachi.com> <20130826111105.5d6504e0@gandalf.local.home>
In-Reply-To: <20130826111105.5d6504e0@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/27 0:11), Steven Rostedt wrote:
> On Mon, 26 Aug 2013 10:50:33 +0900
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>> <Network>
>> 0. old server and old client
>> Old servers send "tracecmd" as the first message.
>> Old clients compare the first 8byte of the first message with "tracecmd".
>>
>> 1. new server
>> - Send "tracecmd-v2" as the first message.
>> - Check the reply message whether the message is "tracecmd-v2" or cpus
>>     value.
>>     If "tracecmd-v2", the server uses new protocol and wait for the
>>     message MSG_TINIT.
>>     If cpus value, the server uses old protocol.
>
> That will kill an old client. Yes it only checks the first 8 bytes, but
> then it gets back a comma separated list of CPUs. As it uses TCP for
> this transaction, the unread "-v2" will end up being read as CPUs by
> the client.

Ah, that's true. This method is inappropriate.

>>
>> 2. new client
>> - Receive the first message.
>> - Check the message whether the message is "tracecmd-v2" or not.
>>     If "tracecmd-v2", the client sends "tracecmd-v2" to the server. Then,
>>     the client sends the message MSG_TINIT.
>>     If "tracecmd", the client sends cpus value as the old protocol.
>>
>
> It will have to be the client that determines if the protocol is v2 or
> not. Basically, after receiving the "tracecmd" the client can send back
> "V2", and then expect the server to reply with "V2" as well. If the
> server does not, then it disconnects from the server and then restarts
> with the old protocol.

OK, let me check that. Even if the old server will receive "V2", the
server will send port numbers instead of "V2" due to the old protocol.
In that time, the new client will disconnect from the old server and
the restarts with the old protocol. Is it OK?

Thanks!
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


