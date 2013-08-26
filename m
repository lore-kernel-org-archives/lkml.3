Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3HZBui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 21:50:38 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56389 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab3HZBug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 21:50:36 -0400
X-AuditID: 85900ec0-d1d29b9000001514-11-521ab46a1abe
Message-ID: <521AB469.40201@hitachi.com>
Date: Mon, 26 Aug 2013 10:50:33 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [RFC PATCH 08/11] trace-cmd: Apply the trace-msg protocol
 for communication between a server and clients
References: <20130819094620.26597.79499.stgit@yunodevel> <20130819094639.26597.44449.stgit@yunodevel> <20130820135658.5a5d6e28@gandalf.local.home>
In-Reply-To: <20130820135658.5a5d6e28@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/21 2:56), Steven Rostedt wrote:
> On Mon, 19 Aug 2013 18:46:39 +0900
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>
>> This message protocol is incompatible with the previous unstructured message
>> protocol. So, if an old(new)-version client tries to connect to an
>> new(old)-version server, the operation should be stopped.
>>
>
> I'm a stickler for backward compatibility. I'm all for extensions.

No problem:)
I also worried about backward compatibility.

> I know this will just complicate things, but I don't mind that. What
> should happen is, it should try to connect with the new protocol, if it
> fails due to an older server, then it needs to fall back to the older
> method, without the added features. We can freeze the older method if
> need be. But I will not let a newer trace-cmd become incompatible with
> an older version. I worked hard to keep it that way. There's only a few
> exceptions to that.
>
> Note, an older client needs to also work as is with a newer server.
>
> Anyway, the old way only needs to stay the same, it does not need added
> features. For that, a switch to the new way is needed.

OK, I'll add the code switching to the new way in order to keep backward
compatibility. Would you give me your comments about following things?

<Network>
0. old server and old client
Old servers send "tracecmd" as the first message.
Old clients compare the first 8byte of the first message with "tracecmd".

1. new server
- Send "tracecmd-v2" as the first message.
- Check the reply message whether the message is "tracecmd-v2" or cpus
   value.
   If "tracecmd-v2", the server uses new protocol and wait for the
   message MSG_TINIT.
   If cpus value, the server uses old protocol.

2. new client
- Receive the first message.
- Check the message whether the message is "tracecmd-v2" or not.
   If "tracecmd-v2", the client sends "tracecmd-v2" to the server. Then,
   the client sends the message MSG_TINIT.
   If "tracecmd", the client sends cpus value as the old protocol.

<Virtio-serial>
This is new feature, so trace-cmd does not need to keep backward
compatibility.

> If you need help in accomplishing this, I'll work with you on that.

Thank you for your kindness!

Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


